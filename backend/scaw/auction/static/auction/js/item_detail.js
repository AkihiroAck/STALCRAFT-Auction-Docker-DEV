document.addEventListener('DOMContentLoaded', function() {
    const container = document.getElementById('chart-container');
    const svg = document.getElementById('salesChart');
    const tooltip = document.getElementById('tooltip');
    const limitInput = document.getElementById('items-limit');
    const applyBtn = document.getElementById('apply-limit');
    const currentLimitButtons = document.querySelectorAll('button#current-limit');
    const loadingIndicator = document.getElementById('loading-indicator');
    const timezoneSelect = document.getElementById('timezone-select');
    const sliderRange = document.getElementById('chart-slider-range');

    const item_category = container.dataset.category;

    // Элементы фильтров
    const minPriceInput = document.getElementById('min-price');
    const maxPriceInput = document.getElementById('max-price');
    const applyPriceFilterBtn = document.getElementById('apply-price-filter');
    const resetPriceFilterBtn = document.getElementById('reset-price-filter');

    // Элементы фильтров для артефактов
    const minPtnInput = document.getElementById('min-ptn');
    const maxPtnInput = document.getElementById('max-ptn');
    const applyPtnFilterBtn = document.getElementById('apply-ptn-filter');
    const resetPtnFilterBtn = document.getElementById('reset-ptn-filter');
    const qltFilterSelect = document.getElementById('qlt-filter');
    const resetQltFilterBtn = document.getElementById('reset-qlt-filter');

    const defaultLimit = 100;
    let allSalesData = [];
    let filteredSalesData = [];
    let isLoading = false;
    let maxAvailableItems = 0;

    // Текущие фильтры
    let currentFilters = {
        minPrice: null,
        maxPrice: null,
        minPtn: null,
        maxPtn: null,
        qlt: null
    };

    // Переменные для управления масштабированием и перемещением
    let currentZoom = 1;
    let currentOffset = 0;
    let isDragging = false;
    let dragStartX = 0;
    let dragStartOffset = 0;
    let visibleDataRange = { start: 0, end: 0 };
    
    // Переменные для touch-событий
    let initialDistance = 0;
    let initialZoom = 1;
    let touchState = 'none'; // 'none', 'scaling', 'dragging'
    let initialTouchPoints = [];

    // Инициализация часового пояса
    function initTimezone() {
        // Пытаемся получить сохраненный часовой пояс
        const savedTimezone = localStorage.getItem('chart_timezone');
        
        // Устанавливаем сохраненное значение или 0 по умолчанию
        timezoneSelect.value = savedTimezone !== null ? savedTimezone : '0';
        
        // Обработчик изменения часового пояса
        timezoneSelect.addEventListener('change', function() {
            localStorage.setItem('chart_timezone', this.value);
            // Перерисовываем график с новым часовым поясом
            if (allSalesData.length > 0) {
                applyTimezoneToData();
                applyFilters();
                drawChart(parseInt(limitInput.value) || defaultLimit);
            }
        });
    }

    // Применение часового пояса к данным
    function applyTimezoneToData() {
        const timezoneOffset = parseInt(timezoneSelect.value) || 0;
        
        allSalesData = allSalesData.map(item => {
            const date = new Date(item.time);
            date.setHours(date.getHours() - (item.timezoneOffset || 0) + timezoneOffset);
            
            return {
                ...item,
                time: date.getTime(),
                timeStr: date.toISOString().replace('T', ' ').slice(0, 19),
                timezoneOffset: timezoneOffset
            };
        });
    }

    // Сбросить все фильтры при загрузке страницы
    minPriceInput.value = '';
    maxPriceInput.value = '';
    currentFilters.minPrice = null;
    currentFilters.maxPrice = null;

    // Загрузка данных с сервера
    async function loadSalesData(limit) {
        if (isLoading) return;

        limit = limit < 2 ? 2 : limit  // Если limit меньше чем 2, то limit будет равен 2

        isLoading = true;
        loadingIndicator.style.display = 'inline-block';
        applyBtn.disabled = true;
        currentLimitButtons.forEach(btn => btn.disabled = true);

        try {
            const response = await fetch(`?limit=${limit}`, {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Cache-Control': 'no-cache'
                }
            });

            if (!response.ok) throw new Error('Network response was not ok');
            const data = await response.json();
            
            // Получаем текущий часовой пояс (0 если еще не инициализирован)
            const timezoneOffset = timezoneSelect ? parseInt(timezoneSelect.value) || 0 : 0;

            const color = data.colors

            const newData = data.sales.map(item => {
                const date = new Date(item.time);
                date.setHours(date.getHours() + timezoneOffset);
                return {
                    time: date.getTime(),
                    price: item.price,
                    name: item.item__name,
                    ...(item.extra_data.qlt !== undefined && { qlt: item.extra_data.qlt }),
                    ...(item.extra_data.ptn !== undefined && { ptn: item.extra_data.ptn }),
                    timeStr: date.toISOString().replace('T', ' ').slice(0, 19),
                    extra_data: item.extra_data,
                    timezoneOffset: timezoneOffset,
                    color: item.extra_data.qlt !== undefined
                        ? Object.values(color)[Math.min(item.extra_data.qlt, 6)]
                        : color[item.item__color]
                };
            });

            // Обновляем данные
            allSalesData = newData.sort((a, b) => b.time - a.time);
            maxAvailableItems = allSalesData.length;

            // Сброс масштабирования и перемещения при загрузке новых данных
            currentZoom = 1;
            currentOffset = 0;

            // Применяем текущие фильтры
            applyFilters();

            // Определяем реальное количество для отображения
            const displayLimit = Math.min(limit, maxAvailableItems);
            drawChart(displayLimit);
            limitInput.value = displayLimit;
        } catch (error) {
            console.error('Error loading sales data:', error);
            svg.innerHTML = `<text x="50%" y="50%" text-anchor="middle">Ошибка загрузки данных</text>`;
        } finally {
            isLoading = false;
            loadingIndicator.style.display = 'none';
            applyBtn.disabled = false;
            currentLimitButtons.forEach(btn => btn.disabled = false);
        }
    }

    // Применение всех активных фильтров
    function applyFilters() {
        filteredSalesData = [...allSalesData];

        // Фильтр по цене
        if (currentFilters.minPrice !== null) {
            filteredSalesData = filteredSalesData.filter(item => item.price >= currentFilters.minPrice);
        }
        if (currentFilters.maxPrice !== null) {
            filteredSalesData = filteredSalesData.filter(item => item.price <= currentFilters.maxPrice);
        }

        // Фильтры для артефактов
        if (item_category === 'artefact') {
            // Фильтр по PTN
            if (currentFilters.minPtn !== null) {
                filteredSalesData = filteredSalesData.filter(item => item.ptn >= currentFilters.minPtn);
            }
            if (currentFilters.maxPtn !== null) {
                filteredSalesData = filteredSalesData.filter(item => item.ptn <= currentFilters.maxPtn);
            }

            // Фильтр по качеству
            if (currentFilters.qlt !== null) {
                filteredSalesData = filteredSalesData.filter(item => item.qlt === currentFilters.qlt);
            }
        }
        
        // Сброс масштабирования и перемещения при изменении фильтров
        currentZoom = 1;
        currentOffset = 0;
    }

    // Инициализация часового пояса
    if (timezoneSelect) {
        initTimezone();
    }

    // Инициализация
    loadSalesData(defaultLimit);
    limitInput.value = defaultLimit;

    // Устанавливаем размеры SVG (оригинальные пропорции)
    function setSvgSize() {
        const containerWidth = container.clientWidth;
        svg.setAttribute('width', containerWidth);
        svg.setAttribute('height', Math.floor(containerWidth * 0.34));
    }

    // Инициализируем размеры
    setSvgSize();
    window.addEventListener('resize', setSvgSize);

    // Функция для отрисовки графика
    function drawChart(limit = defaultLimit) {

        // Берем только последние N записей
        let salesData = filteredSalesData.slice(0, limit);

        // Применяем масштабирование и смещение
        if (currentZoom !== 1 || currentOffset !== 0) {
            const totalPoints = salesData.length;
            const visiblePoints = Math.max(2, Math.floor(totalPoints / currentZoom));
            
            // Вычисляем диапазон видимых точек с учетом смещения
            let startIdx = Math.floor(currentOffset * (totalPoints - visiblePoints));
            startIdx = Math.max(0, Math.min(startIdx, totalPoints - visiblePoints));
            let endIdx = startIdx + visiblePoints;
            
            // Сохраняем видимый диапазон для использования в обработчиках
            visibleDataRange = { start: startIdx, end: endIdx };
            
            salesData = salesData.slice(startIdx, endIdx);
        } else {
            visibleDataRange = { start: 0, end: salesData.length };
        }

        if (salesData.length === 0) {
            svg.innerHTML = '<text x="50%" y="50%" text-anchor="middle">Нет данных, соответствующих фильтрам</text>';
            
            // Сбрасываем ползунок диапазона
            if (sliderRange) {
                sliderRange.style.display = 'none';
            }
            return;
        }

        const width = svg.clientWidth;
        const height = svg.clientHeight;
        const padding = {top: 10, right: 40, bottom: 70, left: 80};

        let minTime, maxTime, minPrice, maxPrice;

        if (salesData.length === 2) {            
            // Для двух точек
            minTime = Math.min(salesData[0].time, salesData[1].time);
            maxTime = Math.max(salesData[0].time, salesData[1].time);
            minPrice = Math.min(salesData[0].price, salesData[1].price);
            maxPrice = Math.max(salesData[0].price, salesData[1].price);

            // Если время одинаковое - добавляем диапазон по времени
            if (minTime === maxTime) {
                minTime -= 3600000; // 1 час назад
                maxTime += 3600000; // 1 час вперед
            }

            // Если цена одинаковая - добавляем диапазон по цене
            if (minPrice === maxPrice) {
                const pricePadding = minPrice * 0.1; // 10% от цены
                minPrice = Math.max(0, minPrice - pricePadding);
                maxPrice = maxPrice + pricePadding;
            }
        } else if (salesData.length === 1) {
            // Если только одна точка, делаем диапазон вокруг нее
            const singleItem = salesData[0];
            minTime = singleItem.time - 3600000; // 1 час назад
            maxTime = singleItem.time + 3600000; // 1 час вперед
            minPrice = Math.max(0, singleItem.price * 0.9); // 10% ниже
            maxPrice = singleItem.price * 1.1; // 10% выше
        } else {
            // Обычный расчет для нескольких точек
            minTime = Math.min(...salesData.map(d => d.time));
            maxTime = Math.max(...salesData.map(d => d.time));
            minPrice = Math.min(...salesData.map(d => d.price));
            maxPrice = Math.max(...salesData.map(d => d.price));
        }

        // Универсальное масштабирование для любых цен
        const priceRange = maxPrice - minPrice;
        const magnitude = Math.pow(10, Math.floor(Math.log10(priceRange)));
        const stepSize = magnitude / (priceRange/magnitude < 5 ? 4 : 1);

        // Добавляем 5% запаса (кроме случая с одной точкой, где мы уже задали диапазон)
        if (salesData.length > 1) {
            const paddingAmount = priceRange * 0.05;
            minPrice = Math.max(0, Math.floor((minPrice - paddingAmount)/stepSize)*stepSize);
            maxPrice = Math.ceil((maxPrice + paddingAmount)/stepSize)*stepSize;
        }


        const xScale = time => padding.left + (time - minTime) / (maxTime - minTime) * (width - padding.left - padding.right);
        const yScale = price => height - padding.bottom - (price - minPrice) / (maxPrice - minPrice) * (height - padding.top - padding.bottom);

        svg.innerHTML = '';

        // Группа для линий графика
        const linesGroup = document.createElementNS("http://www.w3.org/2000/svg", "g");

        // Линия, соединяющая точки
        if (salesData.length > 1) {
            let pathData = `M ${xScale(salesData[0].time)} ${yScale(salesData[0].price)}`;
            for (let i = 1; i < salesData.length; i++) {
                pathData += ` L ${xScale(salesData[i].time)} ${yScale(salesData[i].price)}`;
            }

            const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
            path.setAttribute("d", pathData);
            path.setAttribute("fill", "none");
            path.setAttribute("stroke", "#adadad");
            path.setAttribute("stroke-width", "1");
            path.setAttribute("stroke-opacity", "0.6");
            linesGroup.appendChild(path);
        }

        // Ось Y
        for (let price = minPrice; price <= maxPrice; price += stepSize) {
            const y = yScale(price);
            svg.innerHTML += `
                <line x1="${padding.left}" y1="${y}" x2="${width-padding.right}" y2="${y}" stroke="#eee" stroke-dasharray="2,2"/>
                <text x="${padding.left-7}" y="${y+4}" text-anchor="end" font-size="12">${price.toLocaleString()}</text>
            `;
        }

        // Ось X (Даты снизу)
        const timeStep = (maxTime - minTime) / 15;
        for (let i = 0; i <= 15; i++) {
            const time = minTime + i*timeStep;
            const x = xScale(time);
            const date = new Date(time);
            svg.innerHTML += `
                <line x1="${x}" y1="${height-padding.bottom}" x2="${x}" y2="${padding.top}" stroke="#eee" stroke-dasharray="2,2"/>
                <text x="${x}" y="${height-padding.bottom+10}"
                      text-anchor="end"
                      font-size="12"
                      transform="rotate(-30, ${x}, ${height-padding.bottom+30})"
                      dominant-baseline="hanging">
                    ${date.getFullYear()}-${String(date.getMonth()+1).padStart(2,'0')}-${String(date.getDate()).padStart(2,'0')}
                </text>
            `;
        }

        // Основные линии осей
        svg.innerHTML += `
            <line x1="${padding.left}" y1="${padding.top}" x2="${padding.left}" y2="${height-padding.bottom}" stroke="#333" stroke-width="1.5"/>
            <line x1="${padding.left}" y1="${height-padding.bottom}" x2="${width-padding.right}" y2="${height-padding.bottom}" stroke="#333" stroke-width="1.5"/>
        `;

        // Добавляем линию графика
        svg.appendChild(linesGroup);

        // Точки данных
        salesData.forEach(item => {
            const x = xScale(item.time);
            const y = yScale(item.price);
            const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            circle.setAttribute("cx", x);
            circle.setAttribute("cy", y);
            circle.setAttribute("r", "5");
            circle.setAttribute("fill", item.color);
            circle.setAttribute("class", "data-point");

            // Показать подсказку
            circle.addEventListener('mouseover', (e) => {
                const svgRect = svg.getBoundingClientRect();
                const tooltipPadding = 10;

                tooltip.innerHTML = `
                    <div class="tooltip-title">${item.name}${item.ptn ? ` +${item.ptn}` : ''}</div>
                    <hr class="tooltip-rank-hr" style="color: ${item.color};">
                    <div>${item.timeStr}</div>
                    <div>${Number(item.price).toLocaleString('ru-RU')} руб.</div>
                    <hr style="margin: 5px 0">
                    <div style="color:#666666">${JSON.stringify(item.extra_data)}</div>
                `;
                
                // Покажем tooltip временно, чтобы измерить его размеры
                tooltip.style.display = 'block';
                tooltip.style.left = '0px';
                tooltip.style.top = '0px';

                const tooltipRect = tooltip.getBoundingClientRect();
                
                // Исходные координаты
                let left = svgRect.left + x + 15;
                let top = svgRect.top + y - tooltipRect.height / 2;

                // Ограничения по горизонтали
                if (left + tooltipRect.width > svgRect.right - tooltipPadding) {
                    left = svgRect.left + x - tooltipRect.width - 15;
                } else if (left < svgRect.left + tooltipPadding) left = svgRect.left + tooltipPadding;

                // Ограничения по вертикали
                if (top < svgRect.top + tooltipPadding) {
                    top = svgRect.top + tooltipPadding;
                } else if (top + tooltipRect.height > svgRect.bottom - tooltipPadding) {
                    top = svgRect.bottom - tooltipRect.height - tooltipPadding;
                }

                tooltip.style.left = `${left}px`;
                tooltip.style.top = `${top}px`;
            });

            circle.addEventListener('mouseout', () => {
                tooltip.style.display = 'none';
            });
            circle.addEventListener('wheel', () => {
                tooltip.style.display = 'none';
            });

            svg.appendChild(circle);
        });

        // --- Ползунок диапазона ---
        if (sliderRange) {
            // Показываем только если зум больше 1 и данных больше 2
            if (currentZoom > 1 && filteredSalesData.length > 2) {
                sliderRange.style.display = 'block';

                // Размеры трека
                const svgRect = svg.getBoundingClientRect();
                const trackWidth = svg.clientWidth - 80 - 40; // padding.left/right

                // Доля видимого диапазона
                const total = filteredSalesData.length;
                const visible = visibleDataRange.end - visibleDataRange.start;

                // Инвертируем направление для sliderRange
                const leftFrac = 1 - (visibleDataRange.end / total);
                const rightFrac = 1 - (visibleDataRange.start / total);

                // Позиция и ширина ползунка
                const leftPx = leftFrac * trackWidth;
                const widthPx = (rightFrac - leftFrac) * trackWidth;

                sliderRange.style.left = (80 + leftPx) + 'px';
                sliderRange.style.width = widthPx + 'px';
                sliderRange.style.right = '';
            } else {
                sliderRange.style.display = 'none';
            }
        }
    }

    // Обработчик колесика мыши для масштабирования
    svg.addEventListener('wheel', function(e) {
        e.preventDefault();

        const delta = e.deltaY > 0 ? -1 : 1;
        const rect = svg.getBoundingClientRect();
        const mousePos = 1 - (e.clientX - rect.left) / rect.width;

        const prevZoom = currentZoom;
        const prevOffset = currentOffset;

        // Изменяем масштаб
        const newZoom = Math.max(1, currentZoom * (1 + delta * 0.1));

        // Вычисляем максимально возможный зум (когда останется 2 точки)
        const totalPoints = filteredSalesData.length;
        const maxZoom = totalPoints / 2;
        
        // Применяем ограничение на максимальный зум
        currentZoom = Math.min(newZoom, maxZoom);

        // Если масштаб изменился, корректируем смещение
        if (currentZoom !== prevZoom) {
            // Если вернулись к зуму 1, сбрасываем смещение
            if (currentZoom === 1) {
                currentOffset = 0;
            } else {
                // Вычисляем видимый диапазон до и после масштабирования
                const visiblePointsPrev = Math.max(2, Math.floor(totalPoints / prevZoom));
                const visiblePointsNew = Math.max(2, Math.floor(totalPoints / currentZoom));

                // Позиция курсора в данных до масштабирования
                const cursorIdx = prevOffset * (totalPoints - visiblePointsPrev) + mousePos * visiblePointsPrev;

                // Новое смещение, чтобы сохранить позицию курсора относительно данных
                let newOffset = (cursorIdx - mousePos * visiblePointsNew) / (totalPoints - visiblePointsNew);
                
                // Ограничиваем смещение в допустимых пределах
                newOffset = Math.max(0, Math.min(1, newOffset));

                currentOffset = newOffset;
            }
        }

        drawChart(parseInt(limitInput.value) || defaultLimit);
    });

    // Обработчики для перемещения графика
    svg.addEventListener('mousedown', function(e) {
        if (currentZoom > 1) {
            isDragging = true;
            dragStartX = e.clientX;
            dragStartOffset = currentOffset;
            svg.style.cursor = 'grabbing';
            
            // Предотвращаем выделение текста при перетаскивании
            e.preventDefault();
        }
    });

    // Обработчик перемещения мыши для перетаскивания графика
    document.addEventListener('mousemove', function(e) {
        if (isDragging) {
            const rect = svg.getBoundingClientRect();
            const deltaX = e.clientX - dragStartX;

            // Вычисляем новое смещение с учетом масштаба (чувствительность к перемещению)
            const deltaOffset = deltaX / rect.width;
            currentOffset = Math.max(0, Math.min(1, dragStartOffset + deltaOffset));
            drawChart(parseInt(limitInput.value) || defaultLimit);

            e.preventDefault();
        }
    });

    document.addEventListener('mouseup', function() {
        isDragging = false;
        svg.style.cursor = currentZoom > 1 ? 'grab' : 'default';
    });

    svg.addEventListener('mouseenter', function() {
        svg.style.cursor = currentZoom > 1 ? 'grab' : 'default';
    });

    svg.addEventListener('mouseleave', function() {
        isDragging = false;
    });

    svg.addEventListener('touchstart', function(e) {
        if (e.touches.length === 2) {
            // Начало жеста масштабирования
            touchState = 'scaling';
            initialTouchPoints = Array.from(e.touches).map(t => ({
                clientX: t.clientX,
                clientY: t.clientY
            }));
            initialDistance = Math.hypot(
                e.touches[1].clientX - e.touches[0].clientX,
                e.touches[1].clientY - e.touches[0].clientY
            );
            initialZoom = currentZoom;
            e.preventDefault();
        } else if (e.touches.length === 1 && currentZoom > 1) {
            // Начало перемещения (одним пальцем)
            touchState = 'dragging';
            initialTouchPoints = [{
                clientX: e.touches[0].clientX,
                clientY: e.touches[0].clientY
            }];
            dragStartX = e.touches[0].clientX;
            dragStartOffset = currentOffset;
            svg.style.cursor = 'grabbing';
            e.preventDefault();
        }
    }, { passive: false });

    svg.addEventListener('touchmove', function(e) {
        if (touchState === 'scaling' && e.touches.length >= 2) {
            // Продолжение жеста масштабирования (даже если один палец уже отпущен)
            const currentDistance = Math.hypot(
                e.touches[1].clientX - e.touches[0].clientX,
                e.touches[1].clientY - e.touches[0].clientY
            );
            
            if (initialDistance > 0) {
                const scale = currentDistance / initialDistance;
                const newZoom = initialZoom * scale;
                
                const totalPoints = filteredSalesData.length;
                const maxZoom = totalPoints / 2;
                currentZoom = Math.max(1, Math.min(newZoom, maxZoom));
                
                drawChart(parseInt(limitInput.value) || defaultLimit);
            }
            e.preventDefault();
        } else if (touchState === 'dragging' && e.touches.length === 1) {
            // Перемещение графика
            const deltaX = e.touches[0].clientX - initialTouchPoints[0].clientX;
            const rect = svg.getBoundingClientRect();
            const deltaOffset = deltaX / rect.width;
            currentOffset = Math.max(0, Math.min(1, dragStartOffset + deltaOffset));
            drawChart(parseInt(limitInput.value) || defaultLimit);
            e.preventDefault();
        }
    }, { passive: false });

    svg.addEventListener('touchend', function(e) {
        if (touchState === 'scaling' && e.touches.length < 2) {
            // Завершение масштабирования (отпустили один или оба пальца)
            touchState = 'none';
            initialDistance = 0;
        } else if (touchState === 'dragging' && e.touches.length === 0) {
            // Завершение перемещения
            touchState = 'none';
            isDragging = false;
            svg.style.cursor = currentZoom > 1 ? 'grab' : 'default';
        }
    });

    // Отключаем выделение текста при клике на SVG (для предотвращения выделения при перетаскивании)
    svg.addEventListener('selectstart', function(e) {
        e.preventDefault();
    });

    // Обработчик кнопки применения
    applyBtn.addEventListener('click', function() {
        const limit = parseInt(limitInput.value);
        if (limit >= 2) {
            // Сброс масштабирования и перемещения при загрузке новых данных
            currentZoom = 1;
            currentOffset = 0;
            loadSalesData(limit);
        }
    });

    // Обработчик кнопок лимитов
    currentLimitButtons.forEach(button => {
        button.addEventListener('click', function() {
            const limit = parseInt(this.getAttribute('value'));
            if (limit >= 2) {
                // Сброс масштабирования и перемещения при загрузке новых данных
                currentZoom = 1;
                currentOffset = 0;
                loadSalesData(limit);
            }
        });
    });

    // Обработчик изменения размера окна
    window.addEventListener('resize', function() {
        const limit = parseInt(limitInput.value) || defaultLimit;
        drawChart(limit);
    });

    // Обработчики фильтров по цене
    applyPriceFilterBtn.addEventListener('click', function() {
        const minPrice = minPriceInput.value ? parseInt(minPriceInput.value) : null;
        const maxPrice = maxPriceInput.value ? parseInt(maxPriceInput.value) : null;

        if (minPrice !== null && isNaN(minPrice)) {
            alert('Минимальная цена должна быть числом');
            return;
        }

        if (maxPrice !== null && isNaN(maxPrice)) {
            alert('Максимальная цена должна быть числом');
            return;
        }

        if (minPrice !== null && maxPrice !== null && minPrice > maxPrice) {
            alert('Минимальная цена не может быть больше максимальной');
            return;
        }

        currentFilters.minPrice = minPrice;
        currentFilters.maxPrice = maxPrice;

        applyFilters();
        drawChart(parseInt(limitInput.value) || defaultLimit);
    });

    resetPriceFilterBtn.addEventListener('click', function() {
        minPriceInput.value = '';
        maxPriceInput.value = '';
        currentFilters.minPrice = null;
        currentFilters.maxPrice = null;

        applyFilters();
        drawChart(parseInt(limitInput.value) || defaultLimit);
    });

    // Обработчики фильтров для артефактов
    if (item_category == 'artefact') {
        
        // Сбросить все фильтры при загрузке страницы
        minPtnInput.value = '';
        maxPtnInput.value = '';
        currentFilters.minPtn = null;
        currentFilters.maxPtn = null;
        qltFilterSelect.value = '-1';
        currentFilters.qlt = null;

        applyPtnFilterBtn.addEventListener('click', function() {
            const minPtn = minPtnInput.value ? parseInt(minPtnInput.value) : null;
            const maxPtn = maxPtnInput.value ? parseInt(maxPtnInput.value) : null;

            if (minPtn !== null && (isNaN(minPtn) || minPtn < 0)) {
                alert('Минимальный уровень должен быть положительным числом');
                return;
            }

            if (maxPtn !== null && (isNaN(maxPtn) || maxPtn < 0)) {
                alert('Максимальный уровень должен быть положительным числом');
                return;
            }

            if (minPtn !== null && maxPtn !== null && minPtn > maxPtn) {
                alert('Минимальный уровень не может быть больше максимального');
                return;
            }

            currentFilters.minPtn = minPtn;
            currentFilters.maxPtn = maxPtn;

            applyFilters();
            drawChart(parseInt(limitInput.value) || defaultLimit);
        });

        resetPtnFilterBtn.addEventListener('click', function() {
            minPtnInput.value = '';
            maxPtnInput.value = '';
            currentFilters.minPtn = null;
            currentFilters.maxPtn = null;

            applyFilters();
            drawChart(parseInt(limitInput.value) || defaultLimit);
        });

        // Изменено: фильтр качества применяется сразу при выборе
        qltFilterSelect.addEventListener('change', function() {
            const qltValue = parseInt(this.value);
            currentFilters.qlt = qltValue >= 0 ? qltValue : null;
            applyFilters();
            drawChart(parseInt(limitInput.value) || defaultLimit);
        });

        resetQltFilterBtn.addEventListener('click', function() {
            qltFilterSelect.value = '-1';
            currentFilters.qlt = null;
            applyFilters();
            drawChart(parseInt(limitInput.value) || defaultLimit);
        });
    }
});
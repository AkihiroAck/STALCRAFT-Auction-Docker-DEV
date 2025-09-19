document.addEventListener('DOMContentLoaded', function() {
    const container = document.getElementById('items-container');
    const loading = document.getElementById('loading');
    const searchInput = document.getElementById('search-input');
    const clearBtn = document.getElementById('clear-search');
    
    let state = {
        page: 1,
        isLoading: false,
        currentSearch: '',
        hasMore: true,
        isInitialLoad: true,
        searchTimeout: null
    };

    // Основная функция загрузки данных
    async function loadItems(options = {}) {
        const { reset = false, search = state.currentSearch } = options;
        
        if (state.isLoading || (!reset && !state.hasMore)) return;
        
        state.isLoading = true;
        loading.style.display = 'block';
        
        try {
            const url = new URL(window.location.href);
            const currentPage = reset ? 1 : state.page;
            url.searchParams.set('page', currentPage);
            
            if (search) {
                url.searchParams.set('search', search);
            } else {
                url.searchParams.delete('search');
            }
            
            const response = await fetch(url, {
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            });
            
            if (!response.ok) throw new Error('Network error');
            
            const data = await response.json();
            
            // Всегда очищаем при сбросе (поиске)
            if (reset) {
                container.innerHTML = '';
                state.page = 1; // Сбрасываем пагинацию
            }
            
            if (data.items.length > 0) {
                state.page++; // Увеличиваем только если есть элементы

                const fragment = document.createDocumentFragment();
                
                data.items.forEach(item => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td class="text-center">${item.id}</td>
                        <td>
                            <a href="${item.url}" class="text-decoration-none d-flex align-items-center gap-2">
                                <div class="item-icon-container" style="border-color: ${item.color}">
                                    <img src="https://github.com/EXBO-Studio/stalcraft-database/raw/main/ru/icons/${item.category}/${item.item_id}.png"
                                        alt="${item.name}"
                                        class="item-icon"
                                        loading="lazy"
                                        onerror="this.onerror=null; this.src='/static/auction/media/no_item_icon.png'">
                                </div>
                                ${item.name}
                            </a>
                        </td>
                        <td>${item.category}</td>
                        <td>${item.item_id}</td>
                    `;
                    fragment.appendChild(row);
                });
                
                container.appendChild(fragment);
            } else if (reset) {
                // Добавляем сообщение только при поиске (reset), а не при обычной загрузке
                const noResultsRow = document.createElement('tr');
                noResultsRow.innerHTML = `
                    <td colspan="4" class="text-center p-3"><b>Ничего не найдено</b></td>
                `;
                container.appendChild(noResultsRow);
            }
            
            state.hasMore = data.has_next;
            
        } catch (error) {
            console.error('Ошибка загрузки:', error);
            if (reset) {
                container.innerHTML = `
                    <tr>
                        <td colspan="4" class="text-center text-danger p-3"><b>Ошибка загрузки данных</b></td>
                    </tr>
                `;
            }
        } finally {
            state.isLoading = false;
            loading.style.display = 'none';
            if (state.isInitialLoad) state.isInitialLoad = false;
        }
    }

    function scrollHandler() {
        if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 500 && 
            !state.isLoading && 
            state.hasMore &&
            !state.isInitialLoad) {
            loadItems();
        }
    }

    function handleSearch() {
        clearTimeout(state.searchTimeout);
        const searchValue = searchInput.value.trim();
        
        state.searchTimeout = setTimeout(() => {
            if (searchValue !== state.currentSearch) {
                state.currentSearch = searchValue;
                loadItems({ reset: true, search: searchValue });
            }
        }, 500);
    }

    function handleClear() {
        searchInput.value = '';
        if (state.currentSearch !== '') {
            state.currentSearch = '';
            loadItems({ reset: true, search: '' });
        }
        searchInput.focus();
    }

    searchInput.addEventListener('input', handleSearch);
    clearBtn.addEventListener('click', handleClear);
    window.addEventListener('scroll', scrollHandler);
    
    loadItems({ reset: true });
});
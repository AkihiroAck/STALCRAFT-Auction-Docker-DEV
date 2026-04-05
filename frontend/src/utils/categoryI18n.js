// Этот файл содержит функции для перевода сегментов и путей категорий на русский язык.
// Вы можете расширить объект CATEGORY_SEGMENT_RU, добавив больше сегментов и их переводов по мере необходимости.

export const CATEGORY_SEGMENT_RU = {
    artefact: 'Артефакты',
    biochemical: 'Биохимические',
    electrophysical: 'Электрофизические',
    gravity: 'Гравитационные',
    thermal: 'Термические',
    other_arts: 'Прочие',
    
    armor: 'Броня',
    clothes: 'Одежда',
    combat: 'Боевая',
    combined: 'Комбинированная',
    scientist: 'Научная',
    device: 'Устройства',
    
    attachment: 'Обвесы',
    barrel: 'Надульники и глушители',
    accessory: 'Аксессуары',
    handgrips: 'Рукоятки',
    other: 'Прочие обвесы',
    collimator_sights: 'Прицелы',
    forend: 'Цевья и крепления',
    mag: 'Магазины',
    pistol_handle: 'Пистолетные рукояти',

    backpacks: 'Рюкзаки',
    containers: 'Контейнеры',
    bullet: 'Патроны',
    drink: 'Напитки',
    food: 'Еда',
    grenade: 'Гранаты',
    medicine: 'Медикаменты',
    misc: 'Прочее',
    armor_motif: 'Мотив брони',
    skins: 'Косметика',

    weapon: 'Оружие',
    assault_rifle: 'Автоматы',
    heavy: 'Прочее вооружение',
    machine_gun: 'Пулеметы',
    melee: 'Ближний бой',
    pistol: 'Пистолеты',
    shotgun_rifle: 'Дробовики и ружья',
    sniper_rifle: 'Снайперские винтовки',
    submachine_gun: 'Пистолеты-пулеметы',

    weapon_modules: 'Квазидеструкторы',
    weapon_module: 'Модули',
    weapon_module_core: 'Ядра',
    weapon_module_remover: 'Квазидеструкторы',
}

export function translateCategorySegment(segment) {
    if (!segment) return ''
    return CATEGORY_SEGMENT_RU[segment] || segment
}

export function translateCategoryPath(path) {
    if (!path) return ''
    return String(path)
        .split('/')
        .filter(Boolean)
        .map((segment) => translateCategorySegment(segment))
        .join('/')
}
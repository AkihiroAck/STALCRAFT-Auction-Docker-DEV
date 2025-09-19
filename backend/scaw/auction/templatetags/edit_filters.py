from django import template

register = template.Library()


@register.filter
def split_category(value):
    """
    Получить первую часть категории. Например:
    artefact/electrophysical -> artefact
    """
    
    if "/" in value:
        return value.split("/")[0]
    
    return value


@register.filter
def edit_category(value):
    """
    Корректировка category для item.
    Для перенаправления на сайт с подробностьями.
    Нужен только для перенаправления на сайт другого разработчика.
    """
    
    if value == "artefact":
        return "artefacts"
    elif value == "attachment":
        return "attachments"
    elif value == "medicine" or value == "bullet" or value == "grenade" or value == "food":
        return "consumables"
    elif value == "misc":
        return "other"
    
    return value


@register.filter
def edit_item_id(value):
    """
    Корректировка item_id для item.
    Для перенаправления на сайт с подробностьями.
    Нужен только для перенаправления на сайт другого разработчика.
    Из за того что нет доступа к некоторым item_id,
    они были придуманы сторонними разработчиками.
    """
    
    if value == 'sezonnyi_propusk':
        return "8AjTFOVB"
    
    return value

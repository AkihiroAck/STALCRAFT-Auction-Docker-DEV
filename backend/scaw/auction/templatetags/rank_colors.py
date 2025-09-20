from django import template
from auction.constants import RANK_COLORS

register = template.Library()


@register.filter
def rank_color(value):
    """
    Возвращает цвет, соответствующий рангу.
    """
    
    return RANK_COLORS[value]

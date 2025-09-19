from django import template
from auction.constants import RANK_COLORS

register = template.Library()


@register.filter
def rank_color(value):
    """
    """
    
    return RANK_COLORS[value]

import logging
import inspect
from datetime import datetime
from zoneinfo import ZoneInfo

# ---------------- ИНИЦИАЛИЗАЦИЯ ---------------- #

logger = logging.getLogger("logger")
logger.setLevel(logging.INFO)


class LogFormatter(logging.Formatter):
    def formatTime(self, record, datefmt=None):
        tz = ZoneInfo("Asia/Almaty")
        return datetime.now(tz).strftime("%Y-%m-%d %H:%M:%S")
    
    def format(self, record):
        # Если есть кастомный caller, подставляем его вместо funcName
        if hasattr(record, "caller"):
            record.funcName = record.caller
        return super().format(record)


# формат с указанием функции
formatter = LogFormatter("[%(asctime)s] [%(funcName)s] %(message)s")

# хендлеры создадим позже динамически
console_handler = logging.StreamHandler()
console_handler.setFormatter(formatter)

file_handler = logging.FileHandler("logs.log", encoding="utf-8")
file_handler.setFormatter(formatter)

# чтобы не дублировал
logger.propagate = False


# ---------------- УДОБНАЯ ФУНКЦИЯ ---------------- #

def log(*args, print: bool = True, save: bool = False) -> None:
    """
    Логирует сообщение с указанием функции, из которой был вызов.
    По умолчанию логирует в консоль. Если нужно логировать в файл,
    укажите save=True.

    :param args: Аргументы для логирования.
    :param print: Логировать в консоль.
    :param save: Логировать в файл.
    """
    
    # Формируем сообщение
    message = " ".join(str(a) for a in args)

    # Получаем имя вызывающей функции
    caller = inspect.stack()[1]
    func_name = caller.function

    # Доп. информация
    extra = {"caller": func_name}


    # Настраиваем хендлеры
    logger.handlers.clear()
    if print:
        logger.addHandler(console_handler)
    if save:
        logger.addHandler(file_handler)

    logger.warning(message, extra=extra)

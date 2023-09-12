import config
from service.logs_service.app_logs import config_logs, init_logging


if __name__ == "__main__":
    init_logging()
    config_logs()


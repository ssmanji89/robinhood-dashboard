import logging
import logging_loki

class LokiLogger:
    def __init__(self):
        logging_loki.emitter.LokiEmitter.level_tag = "level"
        handler = logging_loki.LokiHandler(
            url="http://localhost:3100/loki/api/v1/push",
            tags={"application": "robinhood-dashboard"},
            version="1",
        )
        self.logger = logging.getLogger("loki-logger")
        self.logger.addHandler(handler)
        self.logger.setLevel(logging.INFO)

    def info(self, message):
        self.logger.info(message)

    def error(self, message):
        self.logger.error(message)

loki_logger = LokiLogger()

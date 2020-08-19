from main import app, main
import trend_app_protect.start
from trend_app_protect.api.aws_lambda import protect_handler


@protect_handler
@app.decorator.auto_logging
def handler(event, context):
    main(event)

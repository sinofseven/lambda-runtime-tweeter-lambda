from main import app, main


@app.decorator.auto_logging
def handler(event, context):
    main(event)

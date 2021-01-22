from celery import states
import traceback

def handleException(ctask, ex):
    ctask.update_state(
        state=states.FAILURE,
        meta={
            "exc_type": type(ex).__name__,
            "exc_message": traceback.format_exc().split("\n"),
        },
    )
    raise ex
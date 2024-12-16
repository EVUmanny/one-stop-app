import json

def handler(event, context):
    # Parse the incoming event from API Gateway
    try:
        body = json.loads(event.get("body", "{}"))
        user_name = body.get("user_name", "Guest")
        service = body.get("service", "unknown service")

        # Simulate a booking confirmation
        response_message = {
            "message": f"Hello {user_name}, your request to book a {service} has been received!",
            "status": "success"
        }
    except Exception as e:
        response_message = {
            "message": "An error occurred while processing your request.",
            "error": str(e),
            "status": "error"
        }

    # Return response in API Gateway-compatible format
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(response_message)
    }
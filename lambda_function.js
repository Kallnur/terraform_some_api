exports.lambda_handler = async (event, context) => {
    context.callbackWaitsForEmptyEventLoop = false;

    return {
        body: "Response from Some api"
    }
}
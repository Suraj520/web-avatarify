set -e

source scripts/env.sh

# cloudrun args
CONCURRENCY=1
MEMORY="2Gi"
REGION="us-central1"

REMOTE_BUILD=false
REMOTE_BUILD=true
DEPLOY=false
DEPLOY=true


#############################################################
# cloud build
#############################################################
if $REMOTE_BUILD; then
    gcloud builds submit --config cloudbuild.yaml \
    --substitutions _IMAGE="$IMAGE"
fi
#############################################################
# deploy built image
#############################################################
if $DEPLOY; then
    ENV_VARS="API_TOKEN=${API_TOKEN},DEVICE=${DEVICE}"

    
    gcloud run deploy \
        $SERVICE \
        --image $IMAGE \
        --allow-unauthenticated \
        --memory $MEMORY \
        --concurrency $CONCURRENCY \
        --platform managed \
        --set-env-vars "$ENV_VARS" \
        --region $REGION

fi
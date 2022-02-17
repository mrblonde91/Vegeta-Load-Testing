FROM peterevans/vegeta:6.8.1
WORKDIR /app
COPY vegeta.sh vegeta.sh
COPY basic-request.txt basic-request.txt
COPY basic-request-body.txt basic-request-body.txt

RUN apk update && apk add jq && apk add curl
RUN chmod +x ./vegeta.sh .
CMD [ "./vegeta.sh" ]:
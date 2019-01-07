gcloud config set project blue-fang 
gcloud app deploy -v image-py 
curl -X GET "https://blue-fang.appspot.com/img?id=47" 
curl --form upload=pic28.jpg --form press=OK "https://blue-fang.appspot.com/img" 
dev_appserver.py app.yaml 
curl -F meadia=@pic28.png "http://blue-fang.appspot.com/img" 
curl -X POST -F meadia=@pic28.png "http://blue-fang.appspot.com/img" 
curl -X POST -F meadia=@pic28.png "http://blue-fang.appspot.com/img"  --output res.txt 

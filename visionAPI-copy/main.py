# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Sample application that demonstrates how to use the App Engine Images API.

For more information, see README.md.
"""

# [START all]
# [START ImageSummary]

## DOCUMENTATION: https://cloud.google.com/appengine/docs/standard/python/refdocs/google.appengine.api.images
from google.appengine.api import images
from io import BytesIO
from StringIO import StringIO
from base64 import decodestring
import urllib2
import json

import webapp2

## [1] https://cloud.google.com/appengine/docs/standard/python/googlecloudstorageclient/setting-up-cloud-storage

class ImageSummary(webapp2.RequestHandler):

    def createResponse(self,msg):
        res = ""
        res = res + "<!DOCTYPE html>"
        res = res + "<html>"
        res = res + "<body>"
        res = res + "<h1>Response+++:</h1>"
        res = res + "<p>"+msg+"</p>"
        res = res + "</body>"
        res = res + "</html>"
        return res;
    
    def get(self):
        if self.request.get("id"):
            self.response.headers['Content-Type'] = 'text/HTML'
            self.response.out.write(self.createResponse(self.request.get("id")))
        else:
            self.response.headers['Content-Type'] = 'text/plain'
            self.response.write('Hello, World 2018++++!')

        #self.error(404)

        
    def post(self):

        ## test from https://askubuntu.com/questions/650391/send-base64-encoded-image-using-curl :
        #(echo -n '{"image": "'; base64 ~/Pictures/1.jpg; echo '"}') |
        #curl -H "Content-Type: application/json" -d @- "http://blue-fang.appspot.com/img" 
        
        ## Reference
        ## https://stackoverflow.com/questions/49369438/how-do-i-store-a-base64-encoded-image-in-appengine
        res = "EMPTY"
        data = self.request.body
        decdata=json.loads(data)
        
        if decdata:
            #data=urllib2.unquote(data).decode('utf8')
            res=str(len(decdata['image']))  #data.split('data:image/png;base64,')[1]
            img_data=decdata['image']
            #if len(res) > 50:
                #res=res[:50]
            ##img_data = data.split('data:image/png;base64,')[1]
            #img_data = data.split('data=image%2Fpng%3Bbase64%2')[1]
            #img_data = data.split('data=image/png;base64,')[1]
            
            ## Decode base64 and open as Image
            ##img = images.open(BytesIO(base64.b64decode(img_data))) ##base64.decodestring
            img = images.Image(image_data=img_data)
            if img:
                res = "Image WxH = "
                res = res + str(img.format) + ":" + str(img.width)                
                #img.resize(width=50, height=100)
                #img.im_feeling_lucky()
                #thumbnail = img.execute_transforms(output_encoding=images.PNG)
                #meta=thumbnail.get_original_metadata()
                #res = res + "more " + meta.ImageWidth + "x" + meta.ImageLength 

                #self.response.headers['Content-Type'] = 'image/png'
                #self.response.out.write(img)
                #return;

                
        self.response.headers['Content-Type'] = 'text/HTML'
        self.response.out.write(self.createResponse(res))
        return

        #self.error(404)
# [END ImageSummary]


app = webapp2.WSGIApplication([('/img', ImageSummary)], debug=True)
# [END all]

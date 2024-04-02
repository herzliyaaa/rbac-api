

#### To have command bundle install work with proxy on windows do the following:

Edit file .gemrc. Open windows command line and type: `notepad %userprofile%\.gemrc` .

The file .gemrc is open in notepad. Type on a new line http_proxy: 
`http://username:passwordEncodedWithUrlencode@proxyaddress:proxyport`. Password should be encoded with urlencode .

Close the file .gemrc with saving it.
# How to install Ruby

  - On Linux/UNIX:  
  ```$ sudo apt-get install ruby-full```
  - On OS X machines:  
  Install Homebrew. Visit http://brew.sh/   
  ```$ brew install ruby```
  - On Windows machines, you can use RubyInstaller.   
  http://rubyinstaller.org/

  For more info, visit https://www.ruby-lang.org/en/documentation/installation/

# How to install Git

  - Visit https://git-scm.com/downloads

  For more info, visit https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

# How to install Redis
  - Download the stable version   
  http://redis.io/download

  For more info, visit http://redis.io/topics/quickstart

# How to install MongoDB
  - Download the version for your platform  
  https://www.mongodb.com/download-center?jmp=hero#community

  For more info, visit https://docs.mongodb.com/manual/administration/install-community/

<br>
# Skill Example

This Sinatra app is an example of an AneedA skill. It connects to the Yelp search API.  

<br>
**How to set up and deploy**

First, set up your Yelp account:  

1. Visit https://www.yelp.com  
Register for an account and click on the activation email.  
2. Visit https://www.yelp.com/developers/api_console  

![Create Key](https://github.com/iAmPlus/skills-template-sinatra/blob/master/images/create_key.png?raw=true)

Click **Create key** and fill out the form.  


You can use http://example.com for the Website URL.   

![Create Key Form](https://github.com/iAmPlus/skills-template-sinatra/blob/master/images/create_key_form.png?raw=true)

After you click submit you will see your account secrets.  

  <br>
Now, set up your Heroku instance:  

3. Sign up for an account on heroku.com.  
4. Click **New -> Create new app**   
Click the Create app button   
Click Settings on the navbar.   
Copy the Git URL.  
4. Click **Reveal Config Vars**  
Create 4 new config vars with the secrets from Yelp:  
CONSUMER_KEY  
CONSUMER_SECRET  
TOKEN  
TOKEN_SECRET  
5. Click **Resources** on the navbar   
In the Add-ons input field, enter "Heroku Redis"  

![](https://github.com/iAmPlus/skills-template-sinatra/blob/master/images/add_heroku_redis.png?raw=true)

Pick the "Free" version  

![](https://github.com/iAmPlus/skills-template-sinatra/blob/master/images/add_heroku_redis_confirm.png?raw=true)

Click the "Provision" button  
6. In the Add-ons input field, enter "mLab MongoDB"  

![](https://github.com/iAmPlus/skills-template-sinatra/blob/master/images/add_mlab.png?raw=true)

Pick the "Sandbox - Free" version  
Click the "Provision" button  
Click **Settings** on the navbar  
Click the **Reveal Config Vars** button:  
1. In the "KEY" input field, add **MONGO_DB_URI**  
2. In the "VALUE" input field, look for "MONGOLAB_URI" and copy & paste that key into the "VALUE" field.  
3. Click the "Add" button  

![](https://github.com/iAmPlus/skills-template-sinatra/blob/master/images/add_mlab_config.png?raw=true)

<br>
Next, clone and deploy the app:   

6. Open a terminal.   
  Clone the app: `git clone git@github.com:iAmPlus/skills-template-sinatra.git`
7. `cd skills-template-sinatra`
6. `git remote add production <PASTE Git URL>`  
6. Add your SSH key to Heroku.  See this page: https://devcenter.heroku.com/articles/keys
7. `git push production`  

Test by sending requests to your app. The app expects JSON data in the format:
```
{ "nlu_response": 
  { 
    "dialogue": "in_progress", 
    "intent": "search", 
    "mentions": [
      {
        "entity": {
          "artist_id": 447, 
          "artist_name": "pink floyd", 
          "popularity": 0.73
        }, 
        "field_id": "query", 
        "type": "restaurant", 
        "value": "sushi"
      }
    ], 
    "response": "What song do you want hear?" 
  },
  "user_data": {}
}
```

To Test your skill post JSON:  

```
POST https://<YOUR APP URL>/search  
{  "nlu_response":
  {
    "mentions": [ 
      { "field_id": "query",
        "value": "sushi" },
      { "field_id": "location",
        "value": "los angeles" }
    ]
  }
}
```

Example of a response from the Skill:  
```
{
  "Result": {
    "IntroSpeakOut": "Here are the results of your search.",
    "IntroShowSpeech": "Here are the results of your search.",
    "AutoListen": true,
    "CardsData": [
      {
        "Name": "NewsCardList",
        "Id": "UIVerticalList",
        "Title": "KazuNori",
        "Rating": 4.5,
        "SpeakOut": "KazuNori is located at 421 S Main St",
        "ShowSpeech": "KazuNori",
        "ImageUrl": "https://s3-media3.fl.yelpcdn.com/bphoto/9D63gCmIesyBQO15NNG9Xw/ms.jpg"
      },
      ...
    ]
  },
  "ExternalApiRequestTime": 0.004150280030444264
}
```

# How to run locally   

**Run Redis**   
Open a new terminal tab  
```$ redis-server```  

**Run MongoDB**
Open another new terminal tab  
```$ sudo mongod```  
enter your password

**To Run the app**  
Open a second terminal tab   

cd to the project directory   

Setup a new Ruby project by running the following in the terminal:
  1. gem install bundler
  2. bundle

Create a file for storing the secrets:  
  - touch run.sh
  - put the following in the file:
  ```
  #!/bin/sh  

  export CONSUMER_KEY=<YOUR SECRET KEY HERE>  

  export CONSUMER_SECRET=<YOUR SECRET KEY HERE>  

  export TOKEN=<YOUR SECRET KEY HERE>  

  export TOKEN_SECRET=<YOUR SECRET KEY HERE>  

  rackup
  ```

To start the app:
  - in the terminal:
    - source run.sh
  - open Chrome
    - Update the URL in the browser: http://localhost:9292/search?category_filter=sushi&location=los%20angeles

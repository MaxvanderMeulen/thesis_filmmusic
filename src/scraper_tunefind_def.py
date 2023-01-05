#!/usr/bin/env python
# coding: utf-8

# In[1]:


# load packages
import requests
from bs4 import BeautifulSoup
from time import sleep
import csv
from datetime import datetime
import pandas as pd
import random
import json


# In[2]:


# empty lists
urls = []
all_music = []
data = []
all_data = []


# In[3]:


url = 'https://www.tunefind.com/browse/tv'


# In[4]:


# gather urls
response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser")
musicmachine = soup.find_all(class_="GroupedList_item__CRZnU")
for soup in musicmachine:
    my_music = {}
    
    if soup.find('a', href=True) == None: 
        pass
    else:
        link = soup.find('a', href=True)
        if link['href'].startswith('/show'):
            link = 'https://www.tunefind.com' + link['href']
            my_music['link'] = link
            sleep(3)
    urls.append(my_music)


# In[5]:


# gather first page info
for my_music in urls:
    response = requests.get(my_music['link'])
    soup = BeautifulSoup(response.text, "html.parser")
    full_page = soup.find_all(class_="EpisodeListItem_container__dhZur")
    music = {}
    
    if soup.find(class_="TvHeader_title__z0y6G") == None: 
        pass
    else:
        title = soup.find(class_="TvHeader_title__z0y6G").text
        music['title'] = title

    for soup in full_page:
        if soup.find(class_="EpisodeListItem_title__PkSzj") == None: 
            pass
        else:
            season = soup.find(class_="EpisodeListItem_title__PkSzj").text
            music['season'] = season
            
        if soup.find(class_="EpisodeListItem_subtitle__cupzX") == None:
            pass
        else:
            date = soup.find(class_="EpisodeListItem_subtitle__cupzX").text
            music['date'] = date
            
        if soup.find('a', href=True) == None: 
            pass
        else:
            link_season = soup.find('a', href=True)
            if link_season['href'].startswith('/show'):
                link_season = "https://www.tunefind.com" + link_season['href']
                music['link_season'] = link_season
        sleep(3)
        all_music.append(music.copy())


# In[6]:


# define function that retrieves episode info
def retrieve_episode_page_info(soup):
    card = {}
    if soup.find(class_="EpisodeListItem_title__PkSzj") == None:
        card['episode'] = None
    else:
        episode = soup.find(class_="EpisodeListItem_title__PkSzj").text
        card['episode'] = episode

    if soup.find(class_="EpisodeListItem_subtitle__cupzX") == None:
        card['releasedate_episode'] = None
    else:
        releasedate_episode = soup.find(class_="EpisodeListItem_subtitle__cupzX").text
        card['releasedate_episode'] = releasedate_episode

    if soup.find(class_="EpisodeListItem_description__VxFAI") == None:
        card['episode_description'] = None
    else:
        episode_description = soup.find(class_="EpisodeListItem_description__VxFAI").text
        card['episode_description'] = episode_description

    if soup.find('a', href=True) == None:
        card['link_episode'] = None
    else:
        link_episode = soup.find('a', href=True)
        if link_episode['href'].startswith('/show'):
            link_episode = "https://www.tunefind.com" + link_episode['href']
            card['link_episode'] = link_episode
        else:
            card['link_episode'] = None
    return card


# In[7]:


# gather second page info
i = 1
for music in all_music:
    #Get page info
    req = requests.get(music['link_season'])
    soup = BeautifulSoup(req.text, "html.parser")
    full_page_2 = soup.find_all(class_="MainList_item__bR_g9")
    print(f"{i}/{len(all_music)} Looking at {music['link_season']}")
    i += 1
    #Loop over episodes on page
    for soup in full_page_2:
        #retrieve episode data
        episode_info = retrieve_episode_page_info(soup)
        #Add season data
        episode_info['link_season'] = music['link_season']
        episode_info['date'] = music['date']
        episode_info['season'] = music['season']
        episode_info['title'] = music['title']
        
        sleep(2)
        print(episode_info['episode'])
        #Title is none when e.g. ad. Only add info if episode
        if episode_info['episode'] != None:
            data.append(episode_info)


# In[8]:


# print to csv
df = pd.DataFrame(data)
df.to_csv('tunefind_data_episode.csv', sep=";")


# In[9]:


# define function that retrieves song info
def retrieve_song_page_info(soup):
    song = {}
    if soup.find(class_="SongTitle_link__qlRUV") == None: 
        pass
    else:
        song_title = soup.find(class_="SongTitle_link__qlRUV").text
        song['song_title'] = song_title
    
    if soup.find(class_="ArtistSubtitle_subtitle__LaFIf") == None: 
        pass
    else:
        song_artist = soup.find(class_="ArtistSubtitle_subtitle__LaFIf").text
        song['song_artist'] = song_artist
    
    if soup.find(class_="SceneDescription_description__SDFKK") == None: 
        pass
    else:
        scene_description = soup.find(class_="SceneDescription_description__SDFKK").text
        song['scene_description'] = scene_description
            
    return song


# In[ ]:


# shuffle datalist
shuffled = sorted(data, key=lambda L: random.random())
# gather third page info
i = 1
for episode_info in shuffled:
    if episode_info['link_episode'] == None:
        pass
    else:
    
        #Get page info
        req = requests.get(episode_info['link_episode'])
        soup = BeautifulSoup(req.text, "html.parser")
        full_page_3 = soup.find_all(class_="SongRow_container__TbgMq")
        print(f"{i}/{len(data)} Looking at {episode_info['link_episode']}")
        i += 1

        f=open('outputfile_def.json','a',encoding='utf-8')
        counter = 0
        #retrieve episode data
        for soup in full_page_3:  
            try:
                song_info = retrieve_song_page_info(soup)
                now = datetime.now()
                current_time = now.strftime("%H:%M:%S")
                current_date = now.strftime("%d/%m/%Y")
                counter = counter + 1

                writable_data = {'order': counter,
                                 'link_season': episode_info['link_season'],
                                 'date' : episode_info['date'],
                                 'season' : episode_info['season'],
                                 'title' : episode_info['title'],
                                 'episode' : episode_info['episode'],
                                 'releasedate_episode': episode_info['releasedate_episode'],
                                 'episode_description': episode_info['episode_description'],
                                 'song_title' : song_info['song_title'],
                                 'song_artist' : song_info['song_artist'],
                                 'scene_description' : song_info['scene_description'],
                                 'current_time' : current_time,
                                 'current_date' : current_date}
                sleep(2)
                print(song_info['song_title'])
                writable_json = json.dumps(writable_data)
                f.write(writable_json + '\n')

            except (KeyboardInterrupt, SystemExit):
                raise
            except:
                print("error")
                sleep(25)
                continue
        f.close()


# In[ ]:


# print to csv
#df = pd.DataFrame(all_data)
#df.to_csv('tunefind_final.csv', sep=";")


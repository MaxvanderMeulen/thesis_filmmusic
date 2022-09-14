#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#import packages
import requests
from bs4 import BeautifulSoup
from time import sleep
import csv

# empty list + url
urls = []
all_music = []
url = "https://www.tunefind.com/browse/tv"

# gather all urls
response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser")
sleep(3)
musicmachine = soup.find_all(class_="GroupedList_item__CRZnU")
for soup in musicmachine:
    my_music = {}
    
    if soup.find('a', href=True) == None: 
        pass
    else:
        link = soup.find('a', href=True)
        if link['href'].startswith('/show'):
            link = "https://www.tunefind.com" + link['href']
            my_music['link'] = link
            sleep(3)
    urls.append(my_music)
    
# first page
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
        
#second page
for music in all_music:
    req = requests.get(music['link_season'])
    soup = BeautifulSoup(req.text, "html.parser")
    full_page_2 = soup.find_all(class_="EpisodeListItem_container__dhZur")
    for soup in full_page_2:
        if soup.find(class_="EpisodeListItem_title__PkSzj") == None: 
            pass
        else:
            episode = soup.find(class_="EpisodeListItem_title__PkSzj").text
            music['episode'] = episode
        
        if soup.find(class_="EpisodeListItem_subtitle__cupzX") == None: 
            pass
        else:
            releasedate_episode = soup.find(class_="EpisodeListItem_subtitle__cupzX").text
            music['releasedate_episode'] = releasedate_episode
        
        if soup.find(class_="EpisodeListItem_description__VxFAI") == None: 
            pass
        else:
            episode_description = soup.find(class_="EpisodeListItem_description__VxFAI").text
            music['episode_description'] = episode_description
            
        if soup.find('a', href=True) == None: 
            pass
        else:
            link_episode = soup.find('a', href=True)
            if link_episode['href'].startswith('/show'):
                link_episode = "https://www.tunefind.com" + link_episode['href']
                music['link_episode'] = link_episode

        sleep(3)
        all_music.append(music.copy())
        
# thrid page
for music in all_music:
    req = requests.get(music['link_episode'])
    soup = BeautifulSoup(req.text, "html.parser")
    full_page_3 = soup.find_all(class_="SongRow_container__TbgMq")
    counter = 0
    
    for soup in full_page_3:
        counter = counter + 1
        music["order"] = counter
        
        if soup.find(class_="SongTitle_link__qlRUV") == None: 
            pass
        else:
            song_title = soup.find(class_="SongTitle_link__qlRUV").text
            music['song_title'] = song_title
    
        if soup.find(class_="ArtistSubtitle_subtitle__LaFIf") == None: 
            pass
        else:
            song_artist = soup.find(class_="ArtistSubtitle_subtitle__LaFIf").text
            music['song_artist'] = song_artist
    
        if soup.find(class_="SceneDescription_description__SDFKK") == None: 
            pass
        else:
            scene_description = soup.find(class_="SceneDescription_description__SDFKK").text
            music['scene_description'] = scene_description
    
        sleep(3)
        all_music.append(music.copy())
        
# save to csv
keys = all_music[0].keys()

with open('scraper', 'w', newline='') as output_file:
    dict_writer = csv.DictWriter(output_file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(all_music)


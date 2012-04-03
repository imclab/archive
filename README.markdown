# Howling Vibes Archive

This is the online archive of the band Howling Vibes. This app is designed to
scan a local directory for audio files (mp3, wav, flac), leave them untouched,
and just put their names into a DB. After doing that, you can browse the archive
via this web app in order to play and tag those files. Since this is a project
customized to the needs of my band, it's pretty useless for you unless you've
got the same file hierarchy and organisation as we do, or you like to customize
it. Also, this is my first real rails app in deployment. I think you should know
this.

You can, in fact, look at the deployed version which is used as an online
archive of rehearsal recordings at [howlingvibes.com/archive](http://www.howlingvibes.com/archive).

## File Organisation

The audio files are organised in a certain way. All single audio files are in
different directories named after the day of recording. That's pretty much
self-explanatory, but here's an example:

    2011.07.01/01.song.mp3
    2011.07.01/02.song.mp3
    2012.01.22/01.song.mp3
    2012.01.22/02.song.mp3

## Configuration

You can change the archive path (where the app is supposed to look for files) in
the `config/paths.yml` file. You can also specify a `download_url` in there:
this one is used as the base url when direct linking to the audio files.

## Features

- Visitors can create their own user accounts
- Users can tag, comment and up/down-vote songs
- Visitors can listen to the songs via HTML5 <audio> tag, or by clicking on the
  direct link to the audio file

## TODO

Refactoring: 

- Cleaning up SongsArchive::Directory
- Cleaning up `app/controllers/sessions_controller.rb`: Probably move the
  SongsArchive::Directory accessing to the session model. At least that seems
  cleaner to me.
- Cleaning up the `custom.css` file and seperate the custom styles from the H5BP
  stuff, probably into a seperate file.

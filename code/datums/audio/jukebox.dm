/datum/jukebox
	var/atom/owner
	var/sound_id
	var/datum/sound_token/token
	var/list/tracks
	var/index = 1
	var/volume = 20
	var/volume_max = 50
	var/volume_step = 10
	var/frequency = 1
	var/range = 7
	var/falloff = 1
	var/template
	var/ui_title
	var/ui_width
	var/ui_height
	var/playing
	var/announcement_interval = 45 SECONDS
	var/announcement_generation = 0
	var/list/players_in_range = list()



/datum/jukebox/New(atom/_owner, _template, _ui_title, _ui_width, _ui_height)
	. = ..()
	if (QDELETED(_owner) || !istom(_owner))
		qdel(src)
		return
	owner = _owner
	tracks = list()
	for (var/path in GLOB.jukebox_tracks)
		var/singleton/audio/track/track = GET_SINGLETON(path)
		AddTrack(track.display || track.title, track.source)
	sound_id = "[/datum/jukebox]_[sequential_id(/datum/jukebox)]"
	template = _template
	ui_title = _ui_title
	ui_width = _ui_width
	ui_height = _ui_height


/datum/jukebox/Destroy()
	QDEL_NULL_LIST(tracks)
	QDEL_NULL(token)
	owner = null
	return ..()


/datum/jukebox/proc/AddTrack(title = "Track [length(tracks) + 1]", source)
	tracks += new /datum/jukebox_track (title, source)


/datum/jukebox/proc/ClearTracks()
	QDEL_NULL_LIST(tracks)
	tracks = list()


/datum/jukebox/proc/Next()
	if (++index > length(tracks))
		index = 1
	if (playing)
		Stop(TRUE)
		Play()


/datum/jukebox/proc/Last()
	if (--index < 1)
		index = length(tracks)
	if (playing)
		Stop(TRUE)
		Play()


/datum/jukebox/proc/Track(_index)
	_index = text2num(_index)
	if (!IsInteger(_index))
		return
	index = clamp(_index, 1, length(tracks))
	if (playing)
		Stop(TRUE)
		Play()


/datum/jukebox/proc/GetVolumeDescription()
	if (volume <= 0)
		return "muted"
	if (volume <= 10)
		return "very quiet"
	if (volume <= 20)
		return "quiet"
	if (volume <= 30)
		return "moderate"
	if (volume <= 40)
		return "loud"
	return "very loud"


/datum/jukebox/proc/GetMusicMessage()
	var/datum/jukebox_track/track = tracks[index]
	if (!track)
		return null

	return "\The [owner] plays '[track.title]' ([GetVolumeDescription()])."


/datum/jukebox/proc/GetCurrentListeners()
	var/list/listeners = list()

	if (QDELETED(owner))
		return listeners

	var/turf/source = get_turf(owner)
	if (!source)
		return listeners

	for (var/mob/M in range(range, source))
		if (M.client)
			listeners += M

	return listeners


/datum/jukebox/proc/AnnounceMusic()
	if (!playing || QDELETED(owner) || volume <= 0)
		return

	var/message = GetMusicMessage()
	if (!message)
		return

	for (var/mob/M in GetCurrentListeners())
		to_chat(M, message)


/datum/jukebox/proc/AnnounceStop()
	if (QDELETED(owner))
		return

	var/message = "\The [owner] stops playing music."

	for (var/mob/M in GetCurrentListeners())
		to_chat(M, message)


/datum/jukebox/proc/CheckNewListeners()
	if (!playing || QDELETED(owner))
		return

	var/list/current_listeners = GetCurrentListeners()

	if (volume > 0)
		var/message = GetMusicMessage()

		if (message)
			for (var/mob/M in current_listeners)
				if (!(M in players_in_range))
					to_chat(M, message)

	players_in_range = current_listeners


/datum/jukebox/proc/AnnouncementLoop(generation)
	var/elapsed = 0

	while (playing && !QDELETED(owner) && generation == announcement_generation)
		sleep(1 SECOND)

		if (!playing || QDELETED(owner) || generation != announcement_generation)
			break

		elapsed += 1 SECOND

		// Announces to everyone at the 45-second mark.
		if (elapsed >= announcement_interval)
			players_in_range = GetCurrentListeners()
			AnnounceMusic()
			elapsed = 0
		else
			// Only announces to newly arrived players.
			CheckNewListeners()



/datum/jukebox/proc/Stop(silent = FALSE)
	if (playing && !silent)
		AnnounceStop()

	playing = FALSE
	announcement_generation++
	players_in_range.Cut()
	QDEL_NULL(token)
	owner.queue_icon_update()


/datum/jukebox/proc/Play()
	if (playing)
		return

	var/datum/jukebox_track/track = tracks[index]
	if (!track || !track.source)
		return

	playing = TRUE
	token = GLOB.sound_player.PlayLoopingSound(owner, sound_id, track.source, volume, range, falloff, frequency = frequency, prefer_mute = TRUE)
	owner.queue_icon_update()

	announcement_generation++

	// Remembers everyone that is present before the new announcement.
	players_in_range = GetCurrentListeners()

	// Announces the start of the playback.
	AnnounceMusic()

	var/generation = announcement_generation
	spawn(0)
		AnnouncementLoop(generation)


/datum/jukebox/proc/Volume(_volume)
	_volume = text2num(_volume)
	if (!isfinite(_volume))
		return

	var/old_volume = volume

	if (_volume >= 0)
		volume = min(_volume, volume_max)
	else if (_volume == -1)
		volume = max(volume - volume_step, 0)
	else if (_volume == -2)
		volume = min(volume + volume_step, volume_max)

	if (token)
		token.SetVolume(volume)

	if (playing && volume != old_volume)
		players_in_range = GetCurrentListeners()

		if (volume > 0)
			AnnounceMusic()
		else
			AnnounceStop()




/datum/jukebox/proc/ModifyCurrentTrack()
	if (!isadmin(usr.client))
		return
	var/track_name = sanitize(input(usr, "Give the current track a new name.", "Name track") as text|null)
	if (!track_name)
		return
	var/track_file = input(usr, "Pick an audio file. Mono-tracked ogg files are recommended, for file size.", "Upload audio file") as file|null
	if (!track_file)
		return
	var/datum/jukebox_track/track = tracks[index]
	track.title = track_name
	track.source = track_file
	log_and_message_admins("has modified a jukebox track belonging to [src.owner]. New title: '[track_name]' with file [track_file]")
	if (playing)
		Stop(TRUE)
		Play()


/datum/jukebox/nano_host()
	return owner


/datum/jukebox/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = TRUE, datum/topic_state/state = GLOB.default_state)
	var/list/data_tracks = list()
	for (var/i = 1 to length(tracks))
		var/datum/jukebox_track/track = tracks[i]
		data_tracks += list(list("track" = track.title, "index" = i))
	var/datum/jukebox_track/track = tracks[index]
	var/list/data = list(
		"track" = track.title,
		"playing" = playing,
		"volume" = volume,
		"tracks" = data_tracks,
		"is_admin" = isadmin(user.client)
	)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src, ui_key, template, ui_title, ui_width, ui_height, state = state)
		ui.set_initial_data(data)
		ui.open()


/datum/jukebox/Topic(href, href_list)
	switch ("[href_list["act"]]")
		if ("next")
			Next()
		if ("last")
			Last()
		if ("stop")
			Stop()
		if ("play")
			Play()
		if ("volume")
			Volume("[href_list["dat"]]")
		if ("track")
			Track("[href_list["dat"]]")
		if ("modify_track")
			ModifyCurrentTrack()
	return TOPIC_REFRESH



/datum/jukebox_track
	var/title
	var/source


/datum/jukebox_track/New(_title, _source)
	title = _title
	source = _source



GLOBAL_LIST_AS(jukebox_tracks, list(
	/singleton/audio/track/absconditus,
	/singleton/audio/track/ambispace,
	/singleton/audio/track/asfarasitgets,
	/singleton/audio/track/clouds_of_fire,
	/singleton/audio/track/comet_haley,
	/singleton/audio/track/df_theme,
	/singleton/audio/track/digit_one,
	/singleton/audio/track/dilbert,
	/singleton/audio/track/eighties,
	/singleton/audio/track/elevator,
	/singleton/audio/track/elibao,
	/singleton/audio/track/endless_space,
	/singleton/audio/track/floating,
	/singleton/audio/track/hull_rupture,
	/singleton/audio/track/human,
	/singleton/audio/track/inorbit,
	/singleton/audio/track/lasers,
	/singleton/audio/track/level3_mod,
	/singleton/audio/track/lysendraa,
	/singleton/audio/track/marhaba,
	/singleton/audio/track/martiancowboy,
	/singleton/audio/track/misanthropic_corridors,
	/singleton/audio/track/monument,
	/singleton/audio/track/nebula,
	/singleton/audio/track/on_the_rocks,
	/singleton/audio/track/one_loop,
	/singleton/audio/track/pwmur,
	/singleton/audio/track/rimward_cruise,
	/singleton/audio/track/space_oddity,
	/singleton/audio/track/thunderdome,
	/singleton/audio/track/torch,
	/singleton/audio/track/torn,
	/singleton/audio/track/treacherous_voyage,
	/singleton/audio/track/voidsent,
	/singleton/audio/track/wake,
	/singleton/audio/track/wildencounters
))

package main

import "core:fmt"
import ma "vendor:miniaudio"

/* 0 for the native channel count of the device */
AUDIO_CHANNELS :: 0
AUDIO_SAMPLE_RATE :: 0

/* you can load any other file from audio/ directory*/
AUDIO_FILE :: #load("../audio/applause.mp3")

engine: ma.engine
decoder: ma.decoder
sound: ma.sound

play_audio :: proc() {
    engine_config := ma.engine_config_init()
    engine_config.channels = AUDIO_CHANNELS
    engine_config.sampleRate = AUDIO_SAMPLE_RATE
    engine_config.listenerCount = 1


    engine_init_result := ma.engine_init(&engine_config, &engine)
    if engine_init_result != .SUCCESS {
	fmt.panicf("ERROR: failed to init miniaudio engine: %v\n", engine_init_result)
    }
    defer ma.engine_uninit(&engine)
    
    engine_start_result := ma.engine_start(&engine)
    if engine_start_result != .SUCCESS {
	fmt.panicf("ERROR: failed to start miniaudio engine: %v\n", engine_start_result)
    }

    decoder_config := ma.decoder_config_init(
	outputFormat = .f32,
	outputChannels = AUDIO_CHANNELS,
	outputSampleRate = AUDIO_SAMPLE_RATE,
    )
    
    decoder_config.encodingFormat = .mp3

    decoder_result := ma.decoder_init_memory(
	pData = raw_data(AUDIO_FILE),
	dataSize = len(AUDIO_FILE),
	pConfig = &decoder_config,
	pDecoder = &decoder,
    )
    if decoder_result != .SUCCESS {
	fmt.panicf("ERROR: failed to init decoder: %v\n", decoder_result)
    }
    defer ma.decoder_uninit(&decoder)

    sound_result := ma.sound_init_from_data_source(
	pEngine = &engine,
	pDataSource = decoder.ds.pCurrent,
	flags = nil,
	pGroup = nil,
	pSound = &sound,
    )
    if sound_result != .SUCCESS {
	fmt.panicf("ERROR: failed to init sound file from memory: %v\n", sound_result)
    } 
    defer ma.sound_uninit(&sound)
    
    ma.sound_start(&sound)
    for ma.sound_is_playing(&sound) {}
    
    return
}

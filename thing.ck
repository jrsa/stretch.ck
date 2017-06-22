fun complex[][] analyzeSoundFile( string f, int size, int frames )
{
    SndBuf _snd => FFT xform => blackhole;
    size => xform.size;
    
    
    f => _snd.read;
    _snd.samples() => int sampleCount;

    sampleCount / size => int nFrames;
    // nFrames/2 => nFrames;
    size => int sampsPerFrame;
    
    <<< "file has", sampleCount, "samples" >>>;
    <<< "performing", nFrames, size, "point fft analyses" >>>;
    <<< sampsPerFrame, "samples per frame" >>>; 

    complex result[ nFrames ][ size/2 ];
    for( 0 => int i; i < nFrames; i++ )
    {
        size * i => _snd.pos;
        xform.upchuck();
        xform.spectrum( result[ i ] );
        
        size :: samp => now;
        <<< "frame", i, "complete" >>>;
    }    
    <<< "analysis complete" >>>;
    return result;
}

200 => int frameCount;
2048 => int fftSize;
10.0 => float speedFactor;

IFFT resynth => dac;

fftSize => resynth.size;

analyzeSoundFile( "/Users/jrsa/Desktop/soundz/bounced/beat 2.wav", fftSize, frameCount ) @=> complex spectra[][];

<<< spectra.cap() >>>;
<<< spectra[0].cap() >>>;

while( true )
{       
    for( 0 => int i; i < spectra.cap(); i++)
    {
        <<< "playing frame", i >>>;
        for( 0.0 => float x; x < speedFactor; 1.0 +=> x )
        {
            spectra[i] => resynth.transform; 
            fftSize :: samp => now;
        }
    }
}


fun complex[][] analyzeSoundFile( string f, int size, int frames )
{
    SndBuf _snd => FFT xform => blackhole;
    size => xform.size;
    
    
    f => _snd.read;
    _snd.samples() => int sampleCount;
    sampleCount / frames => int sampsPerFrame;
    
    <<< "file has", sampleCount, "samples" >>>;
    <<< "performing", frames, "fft analyses with" >>>;
    <<< sampsPerFrame, "samples per frame" >>>; 
    
    complex result[ frames ][ size/2 ];
    for( 0 => int i; i < frames; i++ )
    {
        sampsPerFrame * i => _snd.pos;
        xform.upchuck();
        xform.spectrum( result[ i ] );
        
        size :: samp => now;
        <<< "frame", i, "complete" >>>;
    }    
    <<< "analysis complete" >>>;
    return result;
}

200 => int frameCount;
16384 $ int => int fftSize;

IFFT resynth => dac;

fftSize => resynth.size;
fftSize => Windowing.hamming => resynth.window;

analyzeSoundFile( "/Users/jrsa/Desktop/soundz/bounced/beat 2.wav", fftSize, frameCount ) @=> complex spectra[][];

<<< spectra.cap() >>>;
<<< spectra[0].cap() >>>;

while( true )
{       
    for( 0 => int i; i < spectra.cap(); i++)
    {
        <<< "playing frame", i >>>;
        spectra[i] => resynth.transform; 
        (resynth.size()/2.0)::samp => now;
    }
}


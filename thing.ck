// analyze() returns a 2D array of STFT analysis frames
// right now, it plays through the input in real audio speed

fun complex[][] analyze(string f, int size) {
    SndBuf _snd => FFT xform => blackhole;
    
    size => xform.size;
    f => _snd.read;
    _snd.samples() / size => int framecount;

    complex result[framecount][size / 2];
    for(0 => int i; i < framecount; i++) {
        size * i => _snd.pos; // seek to next input
        xform.upchuck(); // compute fft
        xform.spectrum(result[i]); // copy result to our 2D array
        
        size::samp => now; // copies samples into the fft object at audio rate... (pls fix)
    }    
    return result;
}

"/Users/jrsa/Desktop/soundz/bounced/beat 2.wav" => string filename;

2048 => int N;
2.0 => float speedFactor;

IFFT resynth => dac;
N => resynth.size;

analyze(filename, N) @=> complex spectra[][];

// continuously resynthesize the input at 
while(true) {       
    for(0 => int i; i < spectra.cap(); i++) {
        for(0.0 => float x; x < speedFactor; 1.0 +=> x) {
            spectra[i] => resynth.transform; 
            N::samp => now;
        }
    }
}

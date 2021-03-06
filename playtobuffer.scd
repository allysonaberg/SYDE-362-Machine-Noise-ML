(
// s = Server.local;
// s.options.device = "H5";
// s.options.numInputBusChannels = 2;
// s.options.numOutputBusChannels = 2;
s.boot;
)

// read a soundfile
d = Buffer.read(s, "/Users/Ally/ControlTest-10.wav");

(
// create a network address and assign it to a global variable
~toWekinator = NetAddr.new("127.0.0.1", 6448);
)

(
x = {
    var in, fft, array, filter;
	in = PlayBuf.ar(1, d, BufRateScale.kr(d), loop: 1);
	filter = HPF.ar(in: in, freq: 200.0, mul: 1.0, add: 0.0);
    fft = FFT(LocalBuf(1024), filter);  // for sampling rates 44100 and 48000
    array = MFCC.kr(fft, 20);
	Out.kr(0, array); // control bus out
}.play;
)

(
c = Bus(\control, 0, 13);
)

// send coefficients
(
r = {

    inf.do {
		c.getn(13, { |val| ~toWekinator.sendMsg("/wek/inputs",*val[0..]) });
		0.01.wait; // 25 frames per second
    }
}.fork
)

r.stop;
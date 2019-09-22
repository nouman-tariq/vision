function [ mov ] = loadVid( path )
%LOADVID Summary of this function goes here
%   Detailed explanation goes here
data = VideoReader(path);
nFrames = data.NumberOfFrames;
vidHeight = data.Height;
vidWidth = data.Width;

%Preallocate movie structure.
mov(1:nFrames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);

%Read one frame at a time.
for k = 1 : nFrames
      fprintf('%d/%d\n',k,nFrames);
      mov(k).cdata = read(data, k);
end


end


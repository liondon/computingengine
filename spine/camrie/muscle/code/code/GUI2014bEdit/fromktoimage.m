%function im_data = fromktoimage(k_data, val)
function im_data = fromktoimage(k_data, val, peKey)

% sliceKey = val.sequence.sliceorientation;

% if strcmp(val.sequence.pedirection,'P--A')
%     if sliceKey==1
%         peKey=1;
%     elseif sliceKey==2
%         peKey=2;
%     end
% elseif strcmp(val.sequence.pedirection,'L--R')
%     if sliceKey==1
%         peKey=2;
%     elseif sliceKey==3
%         peKey=2;
%     end
% elseif strcmp(val.sequence.pedirection,'F--H')
%     if sliceKey==2
%         peKey=1;
%     elseif sliceKey==3
%         peKey=1;
%     end
% end
si = size(k_data);


im_data = fftshift(fft2(fftshift(k_data)));

if peKey==1
    im_data=rot90(im_data,-1);
elseif peKey==2
    im_data=fliplr(im_data);
end
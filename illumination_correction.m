function [ Ihmf_3 ] = illumination_correction( I, sigma )

    M = 2*size(I,1) + 1;
    N = 2*size(I,2) + 1;
    
    % taking a log function below
    [X, Y] = meshgrid(1:N,1:M);
    centerX = ceil(N/2);
    centerY = ceil(M/2);
    gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
    H = exp(-gaussianNumerator./(2*sigma.^2));
    H = 1 - H;
    H = fftshift(H);
    
    % determining alpha, beta variables
    alpha = 0.5;
    beta = 1.5;
    Hemphasis = alpha + beta*H;
    
%     I= gpuArray(I); % Converting GPUarray
    paddedI = padarray(I,ceil(size(I)/2)+1,'replicate');
    paddedI = paddedI(1:end-1,1:end-1);
    paddedI= gather(paddedI);
    If = fft2(paddedI);
    clear paddedI;
%     If=gather(If); I= gather(I);
    
    Iout = real(ifft2(Hemphasis.*If));
    Iout = Iout(ceil(M/2)-size(I,1)/2+1:ceil(M/2)+size(I,1)/2, ...
            ceil(N/2)-size(I,2)/2+1:ceil(N/2)+size(I,2)/2);
    clear I;  
    Ihmf_3 = exp(Iout) - 1;
    clear Iout; 
end


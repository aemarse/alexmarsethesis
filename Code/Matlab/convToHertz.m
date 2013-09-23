function [ hertz ] = convToHertz( mel )

    hertz = 700*exp(mel/1127)-700;

end


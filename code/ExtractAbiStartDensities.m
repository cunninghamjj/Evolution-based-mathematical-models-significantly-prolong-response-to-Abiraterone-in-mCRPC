function [ySAbiStart, yRAbiStart] = ExtractAbiStartDensities(u, yS, yR)


AbiStartTimeIndex = find(u == 1, 1, 'first');

ySAbiStart = yS(AbiStartTimeIndex);
yRAbiStart = yR(AbiStartTimeIndex);


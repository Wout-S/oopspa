function [out] = checksym(A)
%CHECKSYM Summary of this function goes here
%   Detailed explanation goes here
out=tril(A)'./triu(A);
end


function polynomial=find_DSO_CRC_by_exclusion(constraint_length,code_generator,d_tilde,k, m)
% 
% 
% 
%  The algorithm uses the exclusion method to find the degree-m DSO CRC
%  generator polynomial.
%
%   Inputs:
%     1) constraint_length, code_generator: the same as in function "poly2trellis"
%     2) d_tilde: the maximum search distance,usually d_tilde<3*dfree
%     3) k: the length of information sequence
%     4) m: the polynomial degree
%
%   Outputs:
%     1) polynomial: in octal form, with the highest degree on the leftmost
%
%   Warnings:
%     1) Make sure to run "find_dominant_error_event_fast" first to
%        generate the error events.
%

%   Copyright 2020 Hengjie Yang





% if ~exist('error_event','var')
%     [error_event,error_weight]=find_dominant_error_event(constraint_length,code_generator,d_tilde);
% end


load(['error_event_',num2str(constraint_length),'_',num2str(code_generator),'_',num2str(d_tilde),'.mat']);
% make sure to run function "find_dominant_error_event_fast" first!!!

trellis=poly2trellis(constraint_length,code_generator);
spec=distspec(trellis);
dfree=spec.dfree;

total=dec2bin(0:2^(m-1)-1)-'0';
candidate_polynomial=[ones(size(total,1),1),total,ones(size(total,1),1)];
% m, m-1,...,1,0, where deg(m)=deg(0)=1

candidate_polynomial=dec2base(bin2dec(num2str(candidate_polynomial)),8);
max_length=k+m+(constraint_length-1); % max_length=k+m+v
undetected_weight=inf(d_tilde,size(candidate_polynomial,1)); % initialization
selection=true(1,size(candidate_polynomial,1));
location=find(selection==true);
polynomial='0';% initialization
error_length=error_event_length;  
% load('candidate_CRC_at_distance_22.mat');

 
for dist=dfree:d_tilde
    if ~isempty(error_event{dist})  
        temp=zeros(1,size(location,2));
        parfor i=1:size(location,2)
            temp(i)=check_divisible_by_distance(error_event,...
                error_length,candidate_polynomial(location(i),:),dist,max_length);
        end
        for i=1:size(location,2)
            undetected_weight(dist,location(i))=temp(i);
        end
        if dist>=2*dfree % need to consider double error event
            temp=zeros(1,size(location,2));
            parfor i=1:size(location,2)
                temp(i)=check_double_error_divisible_by_distance(error_event,error_length,...
                    candidate_polynomial(location(i),:),dist,dfree,d_tilde,max_length);
            end
            for i=1:size(location,2)
                undetected_weight(dist,location(i))=undetected_weight(dist,location(i))+temp(i);
            end
        end
        min_weight=min(undetected_weight(dist,:));
        selection=true(1,size(candidate_polynomial,1));
        selection(undetected_weight(dist,:)==min_weight)=false;
        selection=~selection; % mark the candidate polynomials selected for next loop
        location=find(selection==true);
        disp(['current distance: ' num2str(dist) '; current candidate size: ' num2str(size(location,2))]) % print current candidate number
%         save(['candidate_CRC_at_distance_' num2str(dist) '.mat'],'location');
        if size(location,2)==1 % only one candidate polynomial left
            polynomial=candidate_polynomial(location(1),:);
            break;
        end
    end
end


    





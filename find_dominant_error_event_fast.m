function [error_event,error_event_length]=find_dominant_error_event_fast(constraint_length,code_generator,d_tilde)
%
%
%   Inputs:
%       1) constraint_length, code_generator: the same parameter of poly2trellis
%       2) d_tilde: the maximum Hamming distance required for search
%
%   Outputs:
%       1) error_event: a d_tilde*1 cells, where the i-th cell is a matrix containing all
%           corresponding input that generates the error event with distance 'd'
%       2) error_event_length: a d_tilde*1 cells, where the i-th cell is a matrix
%           recording the corresponding length of the input
%
%   The algorithm uses brute-force search to find y, but use circular array to
%   save memory
%

%   Copyright 2020 Hengjie Yang



trellis=poly2trellis(constraint_length, code_generator);
% V=constraint_length-1;% number of registers
numStates=trellis.numStates;% number of states
% spect=distspec(trellis);
% dfree=spect.dfree;

MaxIteration=100; % hyperparameter, can be modified if necessary
Zero_State=cell(numStates,1);

for iteration=0:MaxIteration
    disp(['Current trellis depth: ',num2str(iteration)]);
    Column{mod(iteration+1,2)+1}=cell(numStates,1);
    if iteration==0
        next_state=trellis.nextStates(1,2)+1;
        if isempty(Column{mod(iteration+1,2)+1}{next_state})
            Column{mod(iteration+1,2)+1}{next_state}=cell(d_tilde,1);%initialization
        end
        weight=sum(dec2bin(oct2dec(trellis.outputs(1,2)))-'0');
        Column{mod(iteration+1,2)+1}{next_state}{weight}=[Column{mod(iteration+1,2)+1}{next_state}{weight};1];
    else
        for i=2:numStates
            if ~isempty(Column{mod(iteration,2)+1}{i})
                for dist=1:d_tilde
                    if ~isempty(Column{mod(iteration,2)+1}{i}{dist})
                        for j=1:2
                            next_state=trellis.nextStates(i,j)+1;
                            if isempty(Column{mod(iteration+1,2)+1}{next_state})
                                Column{mod(iteration+1,2)+1}{next_state}=cell(d_tilde,1);%initialization
                            end
                            output=trellis.outputs(i,j);
                            weight=sum(dec2bin(oct2dec(output))-'0');
                            temp=Column{mod(iteration,2)+1}{i}{dist}; % get the input list with respect to 'dist'
                            temp=[temp (j-1)*ones(size(temp,1),1)]; % add new input bit
                            if dist+weight<=d_tilde
                            Column{mod(iteration+1,2)+1}{next_state}{dist+weight}=...
                                [Column{mod(iteration+1,2)+1}{next_state}{dist+weight};temp];
                            end
                        end
                    end
                end
            end
        end
    end
    Zero_State{iteration+1}=Column{mod(iteration+1,2)+1}{1};%record current zero state
end

error_event=cell(d_tilde,1);
error_event_length=cell(d_tilde,1);

for iteration=1:MaxIteration
    if ~isempty(Zero_State{iteration})
        for dist=1:d_tilde
            if ~isempty(Zero_State{iteration}{dist})
                if isempty(error_event{dist})
                    error_event{dist}=Zero_State{iteration}{dist};
                else
                    error_event{dist}=[error_event{dist} zeros(size(error_event{dist},1),iteration-size(error_event{dist},2))];
                    error_event{dist}=[error_event{dist};Zero_State{iteration}{dist}];
                end
                error_event_length{dist}=[error_event_length{dist};iteration*ones(size(Zero_State{iteration}{dist},1),1)];
            end
        end
    end
end
% save(['Zero_State_',num2str(constraint_length),'_',num2str(code_generator),'_',num2str(d_tilde),'.mat'],'Zero_State','-v7.3');
save(['error_event_',num2str(constraint_length),'_',num2str(code_generator),'_',num2str(d_tilde),'.mat'],...
    'error_event','error_event_length','-v7.3');
            
        
        
        
        
        
        
        
        
        
        
        
        

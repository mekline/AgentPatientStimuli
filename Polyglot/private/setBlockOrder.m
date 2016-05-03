function [ conditionBlocks ] = setBlockOrder( conditionOrderNum )
%setBlockOrder
%   Returns a cell array where each element is a string representing the
%   condition of the block.
%   
%   In this experiment, there are 16 trial blocks and 3 fixation blocks.
%   We'll make 8 possible condition orders.
%
%   The following condition orders are palindromic:
%   1 and 2
%   3 and 4
%   5 and 6
%   7 and 8
    
    %We will have these trial orders plus all of their palindromes
	trialOrders = {1 2 3 4 5 6 7 8;
                   5 6 7 8 1 2 3 4;
                   3 4 1 8 7 2 6 5;
                   2 6 8 5 3 7 1 4};
	
	
	%We need to display each item twice in a row (once in orginal form and
    %once in quilted form), so duplicate all of the columns.
    [nRows, nCols] = size(trialOrders);
    trialOrdersForward = cell(nRows, nCols*2);
    trialOrdersForward(:,1:2:end) = trialOrders;
    trialOrdersForward(:,2:2:end) = trialOrders;
    
    
    %Create the palindromes for each order and merge them with the forward orders
	trialOrdersPalindrome = fliplr(trialOrdersForward);
    
    [nRows, numTrialBlocks] = size(trialOrdersForward);
    trialOrders = cell(nRows*2, numTrialBlocks);
    trialOrders(1:2:end,:) = trialOrdersForward;
    trialOrders(2:2:end,:) = trialOrdersPalindrome;
    
    %Convert the trial orders to strings
	trialOrders = cellfun(@(x){num2str(x)}, trialOrders);
    
    
    %Add and 'L' or a 'Q' in front of the trial orders to indicate if it
    %should be presented in orginial or quilted form
	numPossibleOrders =  size(trialOrders,1);
    orders = cell(numPossibleOrders, numTrialBlocks);
    orders(:) = {'L'};
    
    Lfirst = [1 2 5 6];
    Qfirst = [3 4 7 8];
    
    orders(Lfirst, 2:2:end) = {'Q'};
    orders(Qfirst, 1:2:end) = {'Q'};
    
    orders = cellfun(@(a,b) [a,b],orders,trialOrders,'uni',false);
    
    
    %Add in the fixation blocks at the beginning, halfway, and at the end
    fixCell = cell(size(orders,1), 1);
    fixCell(:) = {'Fix'};
    
    half = length(orders)/2;
    orders = [fixCell, orders(:,1:half), fixCell, orders(:,half+1:end), fixCell];
    
    %Return the order the user requested
    conditionBlocks = orders(conditionOrderNum, :);
end


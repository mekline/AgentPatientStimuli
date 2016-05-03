function displayText(wPtr, text)
%displayText
%   dsiplays text on wPtr

    %Screen('TextSize', wPtr ,textSize);
	DrawFormattedText(wPtr, text, 'center', 'center'); 
	Screen(wPtr, 'Flip');
end

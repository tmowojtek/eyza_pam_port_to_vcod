// String starts with substring
startsWith(strValue, substring)
{
	for (i = 0; i < strValue.size && i < substring.size; i++)
	{
		if (strValue[i] != substring[i])
		{
			return false;
		}
	}
	return true;
}

// String contains a substring
contains(strValue, substring)
{
	if (substring.size > strValue.size)
		return false;
	for (i = 0; i < strValue.size - (substring.size - 1); i++)
	{
		match = true;
		for (j = 0; j < substring.size; j++)
		{
			if (strValue[i+j] != substring[j])
			{
				match = false;
				break;
			}
		}
		if (match)
			return true;
	}
	return false;
}

// If string contain just numbers, return true
// If string starts with dash and number, like -1337, true is returned
isDigitalNumber(strValue)
{
	for (i = 0; i < strValue.size; i++)
	{
		char = strValue[i];
		charNext = "";
		if ((i+1) < strValue.size)
			char = strValue[i+1];

		if (isDigit(char)  ||  (i == 0 && char == "-" && isDigit(charNext)))
			continue;

		return false;
	}

	return true;
}

isDigit(char)
{
	if (char == "0" ||
	    char == "1" ||
	    char == "2" ||
	    char == "3" ||
	    char == "4" ||
	    char == "5" ||
	    char == "6" ||
	    char == "7" ||
	    char == "8" ||
	    char == "9")
	{
		return true;
	}
	return false;
}

// Return array with separated items
splitString(strValue, delimiter)
{
	if (delimiter == "")
		return strValue;

	array = [];
	buffer = "";
	for (i = 0; i <= strValue.size; i++)
	{
		char = "";

		match = true;
		if (i < strValue.size)
		{
			char = strValue[i];
			for (j = 0; j < delimiter.size; j++)
			{
				if (i + j >= strValue.size || strValue[i+j] != delimiter[j])
				{
					match = false;
					break;
				}
			}
		}

		if (match)
		{
			if (buffer != "")
			{
				array[array.size] = buffer;
				buffer = "";
			}
			i += delimiter.size - 1;
		}
		else
			buffer += char;
	}
	return array;
}


// Remove ^1 colors from string
// may be like: "ahoj^1kokos^^25pica^^^123neco_^^^^1234_^nic^^kok^^1os^^1p2a"
// clean:      	"ahoj^1kokos^5pica^3neco_^4_^nic^^kok^os^p2a"
removeColorsFromString(strValue, keepSingleColors)
{
	clean = "";

	if (!isDefined(strValue))
		return clean;

	maxLevel = -1;
	if (isDefined(keepSingleColors))
		maxLevel = 0;

	deepLevel = 0;
	charLast = "";
	for (j = 0; j < strValue.size; j++)
	{
		char = strValue[j];

		if (char == "^")
		{
			deepLevel++;
		}
		else if (isDigit(char))
		{
			if (deepLevel > 0)
			{
				deepLevel--;
				if (deepLevel == maxLevel)
					clean += "^" + char;
			}
			else
				clean += char;
		}
		else
		{
			for (; deepLevel > 0; deepLevel--)
				clean += "^";
			clean += char;
		}
	}

	return clean;
}

// Prints second in format 00:00:00 (hours are printed only if > 0)
formatTime(timeSec, separator, printSeconds)
{
	if (!isDefined(separator)) separator = ":";
	if (!isDefined(printSeconds)) printSeconds = true;
	timeSec = (int)(timeSec); // to avoid unmatching types 'float' and 'int'
	str = "";
	min = (int)(timeSec / 60);
	hour = (int)(min / 60);
	sec = timeSec % 60;
	//if (hour > 0)
	//{
		if (hour < 10) hour = "0" + hour;
		min = min % 60;
		str += hour + separator;
	//}
	if (min < 10) min = "0" + min;
	if (sec < 10) sec = "0" + sec;

	str += min;
	if (printSeconds)
		str += separator + sec;

	return str;
}

formatTimeRoundReport(timeSec, separator, printSeconds)
{
	if (!isDefined(separator)) separator = ":";
	if (!isDefined(printSeconds)) printSeconds = true;
	timeSec = (int)(timeSec); // to avoid unmatching types 'float' and 'int'
	str = "";
	min = (int)(timeSec / 60);
	hour = (int)(min / 60);
	sec = timeSec % 60;
	if (hour > 0)
	{
		if (hour < 10) hour = "0" + hour;
		min = min % 60;
		str += hour + separator;
	}
	if (min < 10) min = "0" + min;
	if (sec < 10) sec = "0" + sec;

	str += min;
	if (printSeconds)
		str += separator + sec;

	return str;
}

// Add char 's' to the end of the string if num is > 1
plural_s(num, text)
{
	if (num > 1)
		text += "s";
	return num + " " + text;
}

// Format the number into specified number of decimal places
format_fractional(num, fixedPositions, precision)
{
	// Is negative number
	num2 = num;
	if (num < 0)
		num2 *= -1.0;

	// Get the fraction part as integer formated to 9 places
	fraction = "" + (int)((num2 - (int)(num2)) * 1000000000.0);
	fraction2 = "000000000" + fraction;
	//logprint("string:: num=" + num + ", num2=" + num2 + ", fraction=" + fraction + ", fraction2=" + fraction2 + "\n");
	fraction2 = getsubstr(fraction2, fraction2.size - 9);
	fraction2 = getsubstr(fraction2, 0, precision);

	// Format the whole number
	whole = "" + (int)(num2);
	if (whole.size < fixedPositions)
	{
		whole = "000000000" + whole;
		whole = getsubstr(whole, whole.size - fixedPositions);
	}

	sign = "";
	if (num < 0)
		sign = "-";

	return sign + whole + "." + fraction2;
}

// Well, COD2 dont have this function, so create it manually
toUpper(char)
{
	switch (char)
	{
		case "a": char = "A"; break;
		case "b": char = "B"; break;
		case "c": char = "C"; break;
		case "d": char = "D"; break;
		case "e": char = "E"; break;
		case "f": char = "F"; break;
		case "g": char = "G"; break;
		case "h": char = "H"; break;
		case "i": char = "I"; break;
		case "j": char = "J"; break;
		case "k": char = "K"; break;
		case "l": char = "L"; break;
		case "m": char = "M"; break;
		case "n": char = "N"; break;
		case "o": char = "O"; break;
		case "p": char = "P"; break;
		case "q": char = "Q"; break;
		case "r": char = "R"; break;
		case "s": char = "S"; break;
		case "t": char = "T"; break;
		case "u": char = "U"; break;
		case "v": char = "V"; break;
		case "w": char = "W"; break;
		case "x": char = "X"; break;
		case "y": char = "Y"; break;
		case "z": char = "Z"; break;
	}
	return char;
}

toLower(strToLower)
{
	lowerCaseString = "";
	for (i = 0; i < strToLower.size; i++)
	{
		char = strToLower[i];
		switch (char)
		{
			case "A": char = "a"; break;
			case "B": char = "b"; break;
			case "C": char = "c"; break;
			case "D": char = "d"; break;
			case "E": char = "e"; break;
			case "F": char = "f"; break;
			case "G": char = "g"; break;
			case "H": char = "h"; break;
			case "I": char = "i"; break;
			case "J": char = "j"; break;
			case "K": char = "k"; break;
			case "L": char = "l"; break;
			case "M": char = "m"; break;
			case "N": char = "n"; break;
			case "O": char = "o"; break;
			case "P": char = "p"; break;
			case "Q": char = "q"; break;
			case "R": char = "r"; break;
			case "S": char = "s"; break;
			case "T": char = "t"; break;
			case "U": char = "u"; break;
			case "V": char = "v"; break;
			case "W": char = "w"; break;
			case "X": char = "x"; break;
			case "Y": char = "y"; break;
			case "Z": char = "z"; break;
		}
		lowerCaseString += char;
	}
	//logprint("toLower(" + strToLower + ")=" + lowerCaseString + "\n");
	return lowerCaseString;
} 

getsubstr(strValue, from, to)
{
	_from = from;
	if (isDefined(to))
		_to = to;
	else
		_to = strValue.size;
		
	if (strValue.size < _to) _to = strValue.size;
	substring = "";
	for (i = _from; i < _to; i++)
	{
		substring += strValue[i];
	}
	//logprint("String: " + strValue + ", substring: " + substring + "\n");
	return substring;
}
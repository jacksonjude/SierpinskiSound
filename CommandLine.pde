class CommandLine {
  String inputCommand = "";
  String inputCommandError = "";
  String inputCommandSuccess = "";
  String inputCommandCompletion = "";
  boolean devShowing = false;
  boolean devEnabled = false;

  public final String[] commands = {"maxtri","poscolor","audioin","audioout","audiomulti","devicelist","audiopow","start","dev"};

  Boolean holdingControl = false;
  Boolean holdingShift = false;
  int promptPosition = 0;

  public void show(int soundListLength, float amplitude, float colorTimeOffset)
  {
    if (devShowing)
    {
      fill(255);
      textAlign(LEFT);
      text(selectedAudioInput + "," + selectedAudioOutput + "/" + (soundListLength-1) + "  " + amplitude + " " + colorTimeOffset, 10, 20);
      fill(255);
      text("> " + inputCommand.substring(0, promptPosition) + (((frameCount%50 < 50/2 && devEnabled) ? (promptPosition == inputCommand.length() ? "_" : "|") : (promptPosition == inputCommand.length() ? "" : ":")) + inputCommand.substring(promptPosition, inputCommand.length())), 10, 40);
      fill(200, 75, 50);
      text(!inputCommandError.equals("") ? "Error: " + inputCommandError : "", 10, 60);
      fill(40, 180, 60);
      stroke(0);
      text(!inputCommandSuccess.equals("") ? "Success: " + inputCommandSuccess : "", 10, 60);
      fill(40, 60, 180);
      stroke(0);
      text(inputCommandSuccess.equals("") ? "" + inputCommandCompletion : "", 10, 60);
      fill(0,0);
    }
  }

  public void pressingKey(int keyCode)
  {
    if (keyCode == CONTROL)
    {
      holdingControl = true;
      return;
    }

    if (keyCode == SHIFT)
    {
      holdingShift = true;
      return;
    }

    if (keyCode == LEFT && promptPosition > 0) promptPosition--;
    if (keyCode == RIGHT && promptPosition < inputCommand.length()) promptPosition++;

    if (keyCode == ALT || keyCode == 20 || keyCode == SHIFT || keyCode == 0 || keyCode == 157 || keyCode == LEFT || keyCode == RIGHT) return;

    String keyString = str(char(keyCode)).toLowerCase();

    if (keyCode == 186) keyString = ";";
    if (keyCode == 191) keyString = "/";
    if (keyCode == 219) keyString = "[";
    if (keyCode == 221) keyString = "]";
    if (keyCode == 188) keyString = ",";
    if (keyCode == 190) keyString = ".";

    /*if (holdingControl)
    {
      if (keyString.equals("p"))
      {
        String pasteString = cp.pasteString();
        inputCommand = inputCommand.substring(0, promptPosition) + pasteString + inputCommand.substring(promptPosition, inputCommand.length());
        promptPosition += pasteString.length();
      }
      return;
    }*/

    if (holdingShift)
    {
      if (keyString.equals(";"))
        keyString = ":";
      else
        keyString = keyString.toUpperCase();
    }

    if ((key == ENTER || key == RETURN) && !inputCommand.equals("")/* && inputCommand.split(" ").length >= 2*/)
    {
      String inputCommandPart = inputCommand.split(" ")[0];
      String inputCommandValue = (inputCommand.split(" ").length > 1) ? inputCommand.split(" ")[1] : "0";

      inputCommandSuccess = "";
      inputCommandError = "";
      inputCommandCompletion = "";

      switch (inputCommandPart.toLowerCase())
      {
        case "maxtri":
          maxtri = parseInt(inputCommandValue);
          break;
        case "poscolor":
          shouldChangeColor = boolean(inputCommandValue);
          break;
        case "audioin":
          selectedAudioInput = parseInt(inputCommandValue);
          break;
        case "audioout":
          selectedAudioOutput = parseInt(inputCommandValue);
          break;
        case "audiomulti":
          //audioMulti = parseFloat(inputCommandValue);
          break;
        case "audiopow":
          //audioPow = parseFloat(inputCommandValue);
          break;
        case "devicelist":
          inputCommandSuccess = arrayToString(soundList);
          break;
        case "start":
          restartSound();
          break;
        case "dev":
          devShowing = boolean(inputCommandValue);
          break;
        default:
          inputCommandError = "Command not found";
          break;
      }

      if (inputCommandError.equals("") && inputCommandSuccess.equals(""))
      {
        inputCommandSuccess = "Set " + inputCommandPart + " to " + inputCommandValue;
      }

      inputCommand = "";
      promptPosition = 0;
    }
    else if ((key == ENTER || key == RETURN) && inputCommand.length() <= 0)
    {
      devEnabled = !devEnabled;
      devShowing = devEnabled ? true : devShowing;
    }
    else if (key == ENTER || key == RETURN)
    {
      inputCommandSuccess = "";
      inputCommandError = "Type a command, then a value";
      inputCommandCompletion = "";
    }
    else if (devEnabled && key != BACKSPACE && key != DELETE && keyCode != 220 && keyCode != 92 && key != ENTER && key != RETURN && key != TAB && keyCode != 192)
    {
      inputCommand = inputCommand.substring(0, promptPosition) + keyString + inputCommand.substring(promptPosition, inputCommand.length());
      promptPosition++;
    }
    else if ((key == DELETE || key == BACKSPACE || keyCode == 220 || keyCode == 92) && promptPosition > 0)
    {
      inputCommand = inputCommand.substring(0, promptPosition - 1) + inputCommand.substring(promptPosition, inputCommand.length());
      promptPosition--;
    }
    else if ((key == TAB || keyCode == 192) && inputCommand.length() > 0 && inputCommand.split(" ").length == 1)
    {
      ArrayList<String> commandsThatContainSubCommand = new ArrayList<String>();
      for (int i=0; commands.length > i; i++)
      {
        if (commands[i].startsWith(inputCommand))
        {
          commandsThatContainSubCommand.add(commands[i]);
        }
      }

      if (commandsThatContainSubCommand.size() > 0)
      {
        int equalPrefixSize = 0;
        for (int i=0; commandsThatContainSubCommand.get(0).length() > i; i++)
        {
          boolean hasEqualPrefixChar = true;
          for (int j=0; commandsThatContainSubCommand.size() > j; j++)
          {
            if ((commandsThatContainSubCommand.get(j).length()-1 < i) || (commandsThatContainSubCommand.get(j).charAt(i) != commandsThatContainSubCommand.get(0).charAt(i)))
            {
              hasEqualPrefixChar = false;
            }
          }

          if (hasEqualPrefixChar)
          {
            equalPrefixSize = i;
          }
          else
          {
            break;
          }
        }

        inputCommand = commandsThatContainSubCommand.get(0).substring(0, equalPrefixSize+1) + ((commandsThatContainSubCommand.get(0).length() == equalPrefixSize+1 && commandsThatContainSubCommand.size() == 1) ? " " : "");
        //Add completion results to success selection text
        promptPosition = inputCommand.length();

        inputCommandSuccess = "";
        inputCommandError = "";
        inputCommandCompletion = arrayListToString(commandsThatContainSubCommand);
      }
    }
  }

  public void releasedKey(int keyCode)
  {
    if (keyCode == CONTROL) holdingControl = false;
    if (keyCode == SHIFT) holdingShift = false;
  }

  public String arrayListToString(ArrayList arr)
  {
    String str = "[";
    for (Object obj : arr)
      str += obj.toString() + ", ";
    str = str.substring(0, str.length()-2);
    str += "]";
    return str;
  }

  public String arrayToString(Object[] arr)
  {
    String str = "[";
    for (int i=0; i < arr.length; i++)
      str += arr[i].toString() + ", ";
    str = str.substring(0, str.length()-2);
    str += "]";
    return str;
  }
}

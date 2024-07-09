Scriptname zzzmrt_sp_ddi_interface extends Quest

Form[] ddkeys
Bool property bChecked = False Auto Hidden

event OnEndState()
  Utility.Wait(5.0) ; Wait before entering active state to help avoid making function calls to scripts that may not have initialized yet. 
  setVars()
endevent

Function setVars()
  int iIndex = 0
  form restraintsKey = Game.GetFormFromFile(0x01775f, "Devious Devices - Integration.esm")
  if restraintsKey && restraintsKey.getType() == 45
    iIndex += 1
  else
    restraintsKey = None
    Debug.Trace("Simple Prostitution: [DD] Restraint key not found.")
  endif
  form chastityKey = Game.GetFormFromFile(0x008a4f, "Devious Devices - Integration.esm")
  if chastityKey && chastityKey.getType() == 45
    iIndex += 1
  else
    chastityKey = None
    Debug.Trace("Simple Prostitution: [DD] Chastity key not found.")
  endif
  form piercingKey = Game.GetFormFromFile(0x0409a4, "Devious Devices - Integration.esm")
  if piercingKey && piercingKey.getType() == 45
    iIndex += 1
  else
    piercingKey = None
    Debug.Trace("Simple Prostitution: [DD] Piercing key not found.")
  endif
  if iIndex > 0
    ddkeys = utility.createFormArray(iIndex)
    While iIndex > 0
      iIndex -= 1
      if piercingKey && (ddkeys.find(piercingKey) < 0)
        ddkeys[iIndex] = piercingKey
      elseif chastityKey && (ddkeys.find(chastityKey) < 0)
        ddkeys[iIndex] = chastityKey
      elseif restraintsKey && (ddkeys.find(restraintsKey) < 0)
        ddkeys[iIndex] = restraintsKey
      endif
    endWhile
    Debug.Notification("Simple Prostitution: Devious Devices Integration detected.")
  endif
endfunction

Bool function GetIsInterfaceActive()
  if GetState() == "Installed"
    return true
  endif
  return false
endfunction

function PlayerLoadsGame(Bool bForce = False)
  Debug.trace("Simple Prostitution: PlayerLoadsGame() triggered for " + self)

  ; Is the soft dependency installed and is our script in the right state? If not change state.
  if Game.IsPluginInstalled("Devious Devices - Integration.esm")
    if GetState() != "Installed"
      GoToState("Installed")
    elseif bForce
      setVars()
    endif
  else
    if GetState() != ""
      GoToState("")
    endif
  endif
  bChecked = True
endfunction

Int Function iAddRandomKeyToActor(ObjectReference akRef, Int aiNum = 1)
	return 0
endfunction

state Installed
	Int Function iAddRandomKeyToActor(ObjectReference akRef, Int aiNum = 1)
		return zzzmrt_sp_int_ddi._iAddRandomKeyToActor(akRef, ddkeys, aiNum)
	endfunction
endState
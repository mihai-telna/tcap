Class {
	#name : #TCAPActiveDialogueState,
	#superclass : #TCAPDialogueState,
	#category : #'TCAP-Core-State'
}

{ #category : #accessing }
TCAPActiveDialogueState class >> label [
	^ #active
]

{ #category : #indications }
TCAPActiveDialogueState >> indicationTrContinue: aContinueMessage [ 
	self flag: #unchecked.
	aContinueMessage hasDialoguePortion
		ifTrue: [ self halt  ]
		ifFalse: [ 
			dialogue indicationTcContinue: aContinueMessage.
			dialogue processComponentsOf: aContinueMessage ]
]

{ #category : #indications }
TCAPActiveDialogueState >> indicationTrEnd: aMessage [
	self flag: #unchecked.
	dialogue processComponentsOf: aMessage.
	dialogue indicationTcEnd: aMessage.
]

{ #category : #'as yet unclassified' }
TCAPActiveDialogueState >> indicationTrPAbort: anObject [ 
	self flag: #unchecked.
	dialogue notifyPAbort: anObject 
]

{ #category : #'as yet unclassified' }
TCAPActiveDialogueState >> indicationTrUAbort: anObject [
	self flag: #unchecked.
	dialogue notifyUAbort: anObject 
]

{ #category : #'as yet unclassified' }
TCAPActiveDialogueState >> requestTcContinue [
	| continue |
	self flag: #unchecked.
	continue := dialogue newContinueMessage.
	dialogue addPendingMessagesTo: continue.
	dialogue transaction requestTrContinue: continue
]

{ #category : #requests }
TCAPActiveDialogueState >> requestTcEnd: aTerminationBoolean [
	self flag: #unchecked.
	self endDialogue: aTerminationBoolean
]

{ #category : #requests }
TCAPActiveDialogueState >> requestTcUAbort: anAbort [
	| apdu |
	dialogue hasApplicationContext ifTrue: [ 
		apdu := anAbort ifNil: [ dialogue newUAbort serviceUser ] ].
	dialogue transaction requestTrUAbort: (apdu asAbortIn: self factory) .
	dialogue terminate.
]
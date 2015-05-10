Class {
	#name : #TCAPDialogueRequest,
	#superclass : #TCAPDialogueAPDU,
	#category : #'TCAP-Core-Model'
}

{ #category : #'initailize-release' }
TCAPDialogueRequest class >> asn1TypeName [
	^ 'AARQ-apdu'
]

{ #category : #'instance creation' }
TCAPDialogueRequest class >> dispatchInstanceCreationOn: anObjectFactory [ 
	^ anObjectFactory newDialogueRequest
]

{ #category : #'as yet unclassified' }
TCAPDialogueRequest class >> isAsn1ModelClass [
	^ true
]

{ #category : #accessing }
TCAPDialogueRequest >> applicationContextName: aString [
	self at: 'application-context-name' put: aString
]

{ #category : #accessing }
TCAPDialogueRequest >> pduType [
	^ 'dialogueRequest'
]

{ #category : #accessing }
TCAPDialogueRequest >> protocolVersion: aString [
	self at: 'protocol-version' put: aString
]
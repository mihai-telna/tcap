Class {
	#name : #ROSInvocation,
	#superclass : #ROSMessage,
	#instVars : [
		'operation',
		'returnBlock',
		'returnLastBlock',
		'errorBlock',
		'rejectBlock',
		'messageBlock',
		'operationClass',
		'timer',
		'lcancelBlock',
		'defaultHandler'
	],
	#category : #'ROS-Core'
}

{ #category : #'initailize-release' }
ROSInvocation class >> asn1TypeName [
	^ 'Invoke'
]

{ #category : #'instance creation' }
ROSInvocation class >> dispatchInstanceCreationOn: aFactory [ 
	^ aFactory newROSInvocation
]

{ #category : #'as yet unclassified' }
ROSInvocation class >> isAsn1ModelClass [
	^ true
]

{ #category : #'instance creation' }
ROSInvocation class >> operation: anOperation [ 
	^ self new
		operation: anOperation
]

{ #category : #'instance creation' }
ROSInvocation class >> operationObject: anOperationObject [ 
	^ self new
		operation: (ROSOperation on: anOperationObject)
]

{ #category : #'instance creation' }
ROSInvocation class >> operationObject: aROSOperationObject  argument: anASN1Dictionary [ 
	^ self new
		operation: (ROSOperation on: aROSOperationObject);
		argument: anASN1Dictionary
]

{ #category : #accessing }
ROSInvocation class >> rosMessageType [
	^ 'invoke'
]

{ #category : #timer }
ROSInvocation >> cancelTimer [
	timer ifNotNil: [
		timer cancel ]
]

{ #category : #converting }
ROSInvocation >> decodeArgument: aTaggedValue [ 
	^ ASN1 
		read: aTaggedValue 
		usingType: (self operation argumentType).

]

{ #category : #accessing }
ROSInvocation >> defaultHandler: aBlock [
	defaultHandler := aBlock
]

{ #category : #dispatching }
ROSInvocation >> dispatchTo: aDialogue [ 
	aDialogue newRemoteInvocation: self
]

{ #category : #'as yet unclassified' }
ROSInvocation >> errorNamed: aString [
	^ self operation errorNamed: aString
]

{ #category : #initialization }
ROSInvocation >> initialize [
	super initialize.
	operationClass := TCAPReportSuccessAndFailure.
]

{ #category : #accessing }
ROSInvocation >> initializeFromDialogue: aDialogue [
	aDialogue hasApplicationContext 
		ifFalse: [ aDialogue guessAppplicationContextFromOperationCode: self operationCode ].
	"we expect the dialogue to abort any action if no applicationContext can be found so we 
	just proceed"
	operation := ROSOperation on: (
		aDialogue applicationContext operationWithCode: self operationCode).
	self argument: (operation decodeArgument: self argument)
]

{ #category : #actions }
ROSInvocation >> invocationTimerExpired [
	self notifyLCancel
]

{ #category : #'as yet unclassified' }
ROSInvocation >> invokeArgument: anObject [
	operation invokeArgument: anObject on: self 
]

{ #category : #actions }
ROSInvocation >> invokeHandler: aBlock with: anObject [
	self invokeHandler: aBlock with: anObject with: nil 
]

{ #category : #actions }
ROSInvocation >> invokeHandler: aBlock with: anObject with: anotherObject [
	(aBlock ifNil: [ defaultHandler ]) ifNotNil: [ :handler |
		handler cull: anObject cull: anotherObject]
]

{ #category : #accessing }
ROSInvocation >> normalizedOperationName [
	self flag: #todo.
	^ (self operationName copyWithout: $-) asSymbol asMutator.
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyError: anError [
	self invokeHandler: errorBlock with: anError
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyError: anError parameter: anObject [
	self invokeHandler: errorBlock with: anError with: anObject 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyLCancel [
	self invokeHandler: lcancelBlock with: nil 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyReject: aReject [
	self invokeHandler: rejectBlock with: aReject
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyReturn: anObject [
	self invokeHandler: returnBlock with: anObject 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyReturnLast: anObject [
	self invokeHandler: returnLastBlock with: anObject 

]

{ #category : #'as yet unclassified' }
ROSInvocation >> onError: aBlock [
	errorBlock := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onLCancel: aBlock [
	lcancelBlock  := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onMessage: aBlock [
	messageBlock := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onReject: aBlock [
	rejectBlock := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onReturn: aBlock [
	returnBlock := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onReturnLast: aBlock [
	returnLastBlock := aBlock
]

{ #category : #accessing }
ROSInvocation >> opcodeNumber: aNumber [
	(self expandFieldNamed: 'opcode') 
		at: 'local' 
		put: aNumber.
]

{ #category : #accessing }
ROSInvocation >> operation [
	^ operation

]

{ #category : #accessing }
ROSInvocation >> operation: aROSOperation [
	operation := aROSOperation.
	"self opcodeNumber: aROSOperation operationCode "
]

{ #category : #accessing }
ROSInvocation >> operationClass: aClass [ 
	operationClass := aClass isNumber 
		ifTrue: [ TCAPOperationSentClass withNumber: aClass ]
		ifFalse: [  aClass ] 
]

{ #category : #accessing }
ROSInvocation >> operationCode [
	^ (self at: 'opcode') at: 'local'
]

{ #category : #accessing }
ROSInvocation >> operationName [
	^ operation type originalBindingName
]

{ #category : #received }
ROSInvocation >> receivedError: aError [ 
	operationClass receivedError: aError invocation: self   
]

{ #category : #received }
ROSInvocation >> receivedReject: aReject [ 
	self terminateState.
	self notifyReject: aReject.
]

{ #category : #received }
ROSInvocation >> receivedReturnLast: aResultLast [ 
	operationClass receivedReturnLast: aResultLast invocation: self  
]

{ #category : #accessing }
ROSInvocation >> rejectExpireTime [
	^ 10
]

{ #category : #actions }
ROSInvocation >> rejectTimerExpired [

]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnError: aString with: anObject [
	| error |
	error := ROSError new
		parent: self;
		type: ((self asn1TypeNamed: 'ROS') elementAt: ROSError rosMessageType) value;
		id: self id;
		error: (self errorNamed: aString).
		
	anObject ifNotNil: [ 
		 error setParameter: anObject asAsn1Value ].

	self sendMessage: error 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnReject: aDictionary [
	self sendMessage: (
		ROSReject new
			parent: self;
			type: ((self asn1TypeNamed: 'ROS') elementAt: ROSReject rosMessageType) value; 
			id: self id)
 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnResult: aDictionary [
	^ aDictionary asAsn1Value 
		type: self operation resultType
 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnResultLast: aDictionary [
	self sendMessage: (
		ROSResultLast new
			parent: self;
			type: (self asn1TypeNamed: 'ReturnResult') ;
			id: self id;
			result: aDictionary)
 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> sendMessage: aMessage [
	messageBlock ifNotNil: [ 
		messageBlock value: aMessage ]
]

{ #category : #accessing }
ROSInvocation >> startInvocationTimer: aDuration [ 
	timer := OsmoTimeScheduler 
		scheduleIn: aDuration 
		block: [ self invocationTimerExpired  ]
]

{ #category : #timer }
ROSInvocation >> startRejectTimer [
	timer := OsmoTimeScheduler 
		scheduleInSeconds: self rejectExpireTime 
		block: [ self rejectTimerExpired  ]
]

{ #category : #termination }
ROSInvocation >> terminateState [
	self cancelTimer.
]

{ #category : #reject }
ROSInvocation >> waitForReject [
	operationClass := TCAPWaitForReject 
]
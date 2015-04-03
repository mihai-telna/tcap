Class {
	#name : #MAPExampleModels,
	#superclass : #Object,
	#classInstVars : [
		'models'
	],
	#category : #'MAP-Core-Tests'
}

{ #category : #'as yet unclassified' }
MAPExampleModels class >> compileMethod: aSelector returningObject: anObject [ 
 	self class compile: aSelector,'ModelFuel
		^ ', (ByteArray streamContents: [:stream|
			(Smalltalk at: #FLSerializer) serialize: anObject on: stream ]) storeString
]

{ #category : #'as yet unclassified' }
MAPExampleModels class >> models [
	^ models ifNil: [ 
		models := Dictionary new ]
]

{ #category : #'as yet unclassified' }
MAPExampleModels class >> named: aString [ 
	^ self models 
		at: aString 
		ifAbsentPut: [ 
			self readModelNamed: aString ]
	
]

{ #category : #'as yet unclassified' }
MAPExampleModels class >> readModelFromSelector:aString [
	^ (Smalltalk at: #FLMaterializer) 
		materializeFromByteArray: (self perform: aString asSymbol)
]

{ #category : #'as yet unclassified' }
MAPExampleModels class >> readModelNamed: aString [
	^ self readModelFromSelector: aString, 'ModelFuel'
]

{ #category : #'as yet unclassified' }
MAPExampleModels class >> reset [
	models := nil
]

{ #category : #'as yet unclassified' }
MAPExampleModels class >> tcap [
	^ (Smalltalk at: #FLMaterializer) materializeFromByteArray: self tcapModelFuel 
]

{ #category : #'as yet unclassified' }
MAPExampleModels class >> tcapModelFuel [
]
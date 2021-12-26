import Cocoa
import CreateML
import PlaygroundSupport

// Config data set
let basePath = "<DATASET_FILEPATH>"

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "\(basePath)twitter-sanders-apple3.csv"))

print(data)

let (traningData, testingData) = data.randomSplit(by: 0.8, seed: 5)

let sentimentClassifier = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "class")

let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

let evaluationAccuracy = (1.0 * evaluationMetrics.classificationError) * 100

let metaData = MLModelMetadata(author: "tramalho", shortDescription: "sentiment tweeter classifier", version: "1.0")

// create new data model
try sentimentClassifier.write(to: URL(fileURLWithPath: "\(basePath)tweetsentimentclassifier.mlmodel"))

//testing
try sentimentClassifier.prediction(from: "@Apple is a terrible company!")

try sentimentClassifier.prediction(from: "I jjust found the best restaurant ever, and it's @DuckAndWaffle")

try sentimentClassifier.prediction(from: "I think @CocaCola ok")

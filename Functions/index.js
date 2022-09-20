//エントリポイント
//helloGCSGeneric
//ランタイム
//Node.js 16
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const video = require('@google-cloud/video-intelligence').v1;
const fs = require('fs');
const path = require('path');
const os = require('os');
const {Storage} = require('@google-cloud/storage');

require('dotenv').config();

admin.initializeApp();

 
exports.helloGCSGeneric = async(data, context) => {
  const file = data;
  console.log(`  Bucket: ${file.bucket}`);
  console.log(`  File: ${file.name}`);

  console.log(
    `Got file ${file.name} with content type ${file.contentType}`,
);


const videoid = file.name.split('.')[0];
const jsonFile = `${videoid}.json`;
console.log(`videoid ${videoid}`);
console.log(`Object path: '${file.bucket}/${file.name}'`);
const request = {
  inputUri: `gs://functions-test-7bc83.appspot.com/trim3.mp4`,
  outputUri: `gs://functions-test-7bc83-response/${jsonFile}`,
  features: [
    'LABEL_DETECTION',
    'SHOT_CHANGE_DETECTION',
  ],
};

const client = new video.VideoIntelligenceServiceClient();

console.log(`Kicking off client annotation`);
const [operation] = await client.annotateVideo(request);
console.log(`Waiting for operation to complete...`);
const [operationResult] = await operation.promise();

const annotations = operationResult.annotationResults[0];

console.log("ここ");
let json_data = JSON.stringify(annotations);
// console.log(json_data);


// // The ID of your GCS bucket
// const bucketName = 'gs://functions-test-7bc83.appspot.com';
// // The path to your file to upload
// const filePath = json_data;
// // The new ID for your GCS file
// const destFileName = 'new.json';
// // Creates a client
// const storage = new Storage();
// async function uploadFile() {
//   await storage.bucket(bucketName).upload(filePath, {
//     destination: destFileName,
//   });

//   console.log(`${filePath} uploaded to ${bucketName}`);
// }

// uploadFile().catch(console.error);

// const storage = new Storage();
// const myBucket = storage.bucket('gs://functions-test-7bc83.appspot.com');
// // const file = myBucket.file('my-file');
// myBucket.save(json_data).then(function() {});


  const contents = json_data;
  // await admin.firestore().collection('messages').save(contents);
  const writeResult = await admin.firestore().collection('messages').add({original: contents});
  // 処理成功時にメッセージを返す
  // res.json({result: `Message with ID: ${writeResult.id} added.`});



// console.log("ここ");
// console.log(annotations);

const labels = annotations.segmentLabelAnnotations;
labels.forEach(label => {
  console.log(`Label ${label.entity.description} occurs at:`);
  label.segments.forEach(segment => {
    const time = segment.segment;
    if (time.startTimeOffset.seconds === undefined) {
      time.startTimeOffset.seconds = 0;
    }
    if (time.startTimeOffset.nanos === undefined) {
      time.startTimeOffset.nanos = 0;
    }
    if (time.endTimeOffset.seconds === undefined) {
      time.endTimeOffset.seconds = 0;
    }
    if (time.endTimeOffset.nanos === undefined) {
      time.endTimeOffset.nanos = 0;
    }
    console.log(
      `\tStart: ${time.startTimeOffset.seconds}` +
        `.${(time.startTimeOffset.nanos / 1e6).toFixed(0)}s`
    );
    console.log(
      `\tEnd: ${time.endTimeOffset.seconds}.` +
        `${(time.endTimeOffset.nanos / 1e6).toFixed(0)}s`
    );
    console.log(`\tConfidence: ${segment.confidence}`);
  });
});

console.log('operation', operation);

};

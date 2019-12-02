// Imports the Google Cloud Tasks library.
const {CloudTasksClient} = require('@google-cloud/tasks');

// Instantiates a client.
const client = new CloudTasksClient();

const project = 'thagomizer-home-automation';
const queue = 'door-locker';
const location = 'us-central1';
const parent = client.queuePath(project, location, queue);

var task = {
  httpRequest: {
    httpMethod: 'POST',
  },
};

/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */

exports.locker = (req, res) => {
    task.scheduleTime = {
    	seconds: parseInt(process.env.DELAY) + Date.now() / 1000,
    };

    task.httpRequest.url = process.env.BACKDOOR;
  
    console.log('Sending task:');
    console.log(task);
    const request = {parent, task};
    const response = client.createTask(request);
    console.log(`Created task ${response.name}`);

    res.status(200).send("Success");
};

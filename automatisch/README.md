# Flowndly - Open Source Zapier Alternative

![Flowndly - Screenshot](https://user-images.githubusercontent.com/2501931/191562539-e42f6c34-03c7-4dc4-bcf9-7f9473a9c64f.png)

🧐 Flowndly is a business automation tool that lets you connect different services like Twitter, Slack, and more to automate your business processes.

💸 Automating your workflows doesn't have to be a difficult or expensive process. You also don't need any programming knowledge to use Flowndly.

## Advantages

There are other existing solutions in the market, like Zapier and Integromat, so you might be wondering why you should use Flowndly.

✅ One of the main benefits of using Flowndly is that it allows you to store your data on your own servers, which is essential for businesses that handle sensitive user information and cannot risk sharing it with external cloud services. This is especially relevant for industries such as healthcare and finance, as well as for European companies that must adhere to the General Data Protection Regulation (GDPR).

🤓 Your contributions are vital to the development of Flowndly. As an open-source software, anyone can have an impact on how it is being developed.

💙 No vendor lock-in. If you ever decide that Flowndly is no longer helpful for your business, you can switch to any other provider, which will be easier than switching from the one cloud provider to another since you have all data and flexibility.

## Installation

```bash
# Clone the repository
git clone https://github.com/kyberium11/flowndly.git

# Go to the repository folder
cd flowndly

# Start
docker compose up
```

You can use `user@automatisch.io` email address and `sample` password to login to Flowndly. Please do not forget to change your email and password from the settings page.

For other installation types, you can check the deployment guides in this repository.

## Deployment

Flowndly can be deployed to various platforms:

- **Render**: One-click deployment with managed databases
- **Railway**: Simple Docker deployment
- **DigitalOcean**: Docker-native platform
- **VPS**: Full control with Docker Compose

See the deployment guides in this repository for detailed instructions.

## Support

If you have any questions or problems, please visit our GitHub issues page, and we'll try to help you as soon as possible.

[https://github.com/kyberium11/flowndly/issues](https://github.com/kyberium11/flowndly/issues)

## License

Flowndly Community Edition (Flowndly CE) is an open-source software with the [AGPL-3.0 license](LICENSE.agpl).

Flowndly Enterprise Edition (Flowndly EE) is a commercial offering with the [Enterprise license](LICENSE.enterprise).

The Flowndly repository contains both AGPL-licensed and Enterprise-licensed files. We maintain a single repository to make development easier.

All files that contain ".ee." in their name fall under the [Enterprise license](LICENSE.enterprise). All other files fall under the [AGPL-3.0 license](LICENSE.agpl).

See the [LICENSE](LICENSE) file for more information.

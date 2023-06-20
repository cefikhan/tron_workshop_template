## Quick Start
### Prereq you must have docker installed in your system

### Install<br>
Before you can use TronBox, install it using the npm command.
```
$ npm install -g tronbox
```
### Install Packages for monorepo<br>
Navigate to root directory of TNS ,run command.
```
$ yarn
```
### Compile the Smart Contracts<br>
From root directory of TNS ,run command.
```
$ yarn workspace smartcontracts compile
```

### Pull Tron Runtime Environment<br>
From root directory of TNS ,run command.
```
$ yarn workspace smartcontracts pull-tre
```

### Spin up the local blockchain<br>
From root directory of TNS ,run command.
```
$ yarn workspace smartcontracts spin-blockchain
```

### Test the Smart Contracts<br>
From root directory of TNS ,run command.
```
$ yarn workspace smartcontracts test
```

### Start the frontEnd<br>
From root directory of TNS ,run command.
```
$ yarn workspace frontend start
```

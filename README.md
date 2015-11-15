# Up and Running

Have a basic web service up and running (hence the name) in less than 5 minutes*!!!

## Usage

```sh
$ ruby up_and_run.rb project_name ruby_version project_path server
```
Example

```sh
$ ruby up_and_run.rb test_service 2.2.1 /home/greatestuser/Desktop puma
```

Afterwards, run
```sh
$ bundle install
```
and, depending on your choice of server
```sh
$ rackup # for thin
```
```sh
$ puma # for puma
```
Working on Gemifying it...coming soon.

*I have not measured the actual time it takes to get it up and running but still, this beats all that file copying and typing.

# troubleshooting network services

In this lab environment, you can practice [bottom up troubleshooting](https://hogenttin.github.io/linux-training-hogent/opslinux/troubleshooting/) of network services. The environment consists of two AlmaLinux 9 VMs:

| Host   | IP            | Service                 |
| :----- | :------------ | :---------------------- |
| `webt` | 192.168.76.72 | Apache web server       |
| `dbt`  | 192.168.76.73 | MariaDB database server |

The database server is configured correctly, but the web server is not. Your task is to troubleshoot the web server and get it working.

When successful, you should be able to see the webpage hosted on `webt` from your host system by pointing a web browser to <http://192.168.56.72/test.php>:

![PHP application running on webt](result.png)

The PHP page should perform a query on the database server and display the result.

Start the environment by running `vagrant up` from a terminal in this directory. You can then log in to the web server with `vagrant ssh webt` and to the database server with `vagrant ssh dbt`.

There's a test script available to check that the database server is running correctly. When logged in to `dbt`, run the following command:

```console
$ /vagrant/query_db.sh
+ mysql --host=192.168.76.73 --user=demo_user \
+:   --password=ArfovWap_OwkUfeaf4 demo \
+   '--execute=SELECT * FROM demo_tbl;'
+----+-------------------+
| id | name              |
+----+-------------------+
| 1  | Tuxedo T. Penguin |
| 2  | Bobby Tables      |
+----+-------------------+
+ set +x
```

The script can be run from any Linux machine on the same network as the database server if it has the command `mysql` installed.

Have fun & good luck!

## Issues

If you get the following error when starting the environment on a Linux system:

```console
$ vagrant up
Bringing machine 'dbt' up with 'virtualbox' provider...
Bringing machine 'webt' up with 'virtualbox' provider...
==> dbt: Checking if box 'bento/almalinux-9' version '202405.07.0' is up to date...
==> dbt: Clearing any previously set network interfaces...
The IP address configured for the host-only network is not within the
allowed ranges. Please update the address used to be within the allowed
ranges and run the command again.

  Address: 192.168.76.73
  Ranges: 192.168.56.0/21

Valid ranges can be modified in the /etc/vbox/networks.conf file. For
more information including valid format see:

  https://www.virtualbox.org/manual/ch06.html#network_hostonly
```

Add the following line to the `/etc/vbox/networks.conf` file or create the file if it doesn't exist (and ensure it is world readable):

```text
* 0.0.0.0/0 ::/0
```

Then run `vagrant up` again.

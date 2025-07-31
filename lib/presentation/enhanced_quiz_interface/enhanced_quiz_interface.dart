import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/enhanced_quiz_header_widget.dart';
import './widgets/enhanced_quiz_question_widget.dart';
import './widgets/enhanced_quiz_navigation_widget.dart';
import './widgets/enhanced_quiz_results_widget.dart';
import './widgets/enhanced_quiz_review_widget.dart';

class EnhancedQuizInterface extends StatefulWidget {
  const EnhancedQuizInterface({super.key});

  @override
  State<EnhancedQuizInterface> createState() => _EnhancedQuizInterfaceState();
}

class _EnhancedQuizInterfaceState extends State<EnhancedQuizInterface>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _questionController;
  late Animation<Offset> _questionSlideAnimation;

  // Quiz state management
  int _currentQuestionIndex = 0;
  String _selectedSubject = 'AIJ'; // Default subject
  Map<int, int> _userAnswers = {};
  Set<int> _flaggedQuestions = {};
  bool _quizCompleted = false;
  bool _showResults = false;
  DateTime? _quizStartTime;
  DateTime? _quizEndTime;

  // Subject-specific quiz data
  final Map<String, List<Map<String, dynamic>>> _subjectQuizzes = {
    'AIJ': [
      {
        "id": 1,
        "question": "Apa kepanjangan dari TCP dalam protokol jaringan?",
        "imageUrl": null,
        "options": [
          "Transfer Control Protocol",
          "Transmission Control Protocol",
          "Transport Communication Protocol",
          "Technical Control Protocol"
        ],
        "correctAnswer": 1,
        "explanation":
            "TCP (Transmission Control Protocol) adalah protokol yang menyediakan layanan pengiriman data yang handal dan berurutan dalam jaringan komputer."
      },
      {
        "id": 2,
        "question": "Berapa jumlah bit dalam alamat IPv4?",
        "imageUrl":
            "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "options": ["16 bit", "24 bit", "32 bit", "64 bit"],
        "correctAnswer": 2,
        "explanation":
            "Alamat IPv4 terdiri dari 32 bit yang dibagi menjadi 4 oktet, masing-masing berisi 8 bit. Contoh: 192.168.1.1"
      },
      {
        "id": 3,
        "question": "Manakah yang merupakan perangkat Layer 2 dalam model OSI?",
        "imageUrl": null,
        "options": ["Router", "Hub", "Switch", "Gateway"],
        "correctAnswer": 2,
        "explanation":
            "Switch beroperasi pada Layer 2 (Data Link Layer) dan menggunakan MAC address untuk meneruskan frame data antar perangkat dalam jaringan lokal."
      },
      // ... continue with 17 more AIJ questions to total 20
      {
        "id": 4,
        "question": "Apa fungsi utama dari subnet mask?",
        "imageUrl": null,
        "options": [
          "Mengenkripsi data jaringan",
          "Membagi jaringan menjadi subnet yang lebih kecil",
          "Mengatur kecepatan transfer data",
          "Menyimpan alamat MAC perangkat"
        ],
        "correctAnswer": 1,
        "explanation":
            "Subnet mask digunakan untuk membagi jaringan IP menjadi subnet yang lebih kecil dan menentukan bagian network dan host dari alamat IP."
      },
      {
        "id": 5,
        "question": "Port berapa yang digunakan oleh protokol HTTP?",
        "imageUrl": null,
        "options": ["Port 21", "Port 25", "Port 80", "Port 443"],
        "correctAnswer": 2,
        "explanation":
            "HTTP (HyperText Transfer Protocol) menggunakan port 80 sebagai port default untuk komunikasi web yang tidak terenkripsi."
      },
      // Adding more questions to reach 20 total
      {
        "id": 6,
        "question": "Apa itu VLAN dalam jaringan komputer?",
        "imageUrl": null,
        "options": [
          "Virtual Local Area Network",
          "Very Large Area Network",
          "Variable Length Access Network",
          "Virtual Link Access Network"
        ],
        "correctAnswer": 0,
        "explanation":
            "VLAN (Virtual Local Area Network) adalah teknologi yang memungkinkan pembagian jaringan secara logis tanpa harus mengubah infrastruktur fisik."
      },
      {
        "id": 7,
        "question": "Protokol mana yang digunakan untuk mengirim email?",
        "imageUrl": null,
        "options": ["HTTP", "FTP", "SMTP", "DNS"],
        "correctAnswer": 2,
        "explanation":
            "SMTP (Simple Mail Transfer Protocol) adalah protokol standar untuk mengirim email melalui internet."
      },
      {
        "id": 8,
        "question": "Apa kepanjangan dari DNS?",
        "imageUrl": null,
        "options": [
          "Domain Name System",
          "Dynamic Network Service",
          "Data Network Security",
          "Digital Name Server"
        ],
        "correctAnswer": 0,
        "explanation":
            "DNS (Domain Name System) adalah sistem yang menerjemahkan nama domain menjadi alamat IP."
      },
      {
        "id": 9,
        "question": "Berapa maksimal hop count dalam protokol RIP?",
        "imageUrl": null,
        "options": ["10", "15", "20", "255"],
        "correctAnswer": 1,
        "explanation":
            "RIP (Routing Information Protocol) memiliki maksimal hop count 15, di mana hop count 16 dianggap sebagai infinite."
      },
      {
        "id": 10,
        "question": "Apa fungsi dari firewall dalam jaringan?",
        "imageUrl": null,
        "options": [
          "Mempercepat koneksi internet",
          "Menyaring dan mengontrol lalu lintas jaringan",
          "Mengatur bandwidth",
          "Menyimpan data backup"
        ],
        "correctAnswer": 1,
        "explanation":
            "Firewall berfungsi untuk menyaring dan mengontrol lalu lintas jaringan berdasarkan aturan keamanan yang telah ditetapkan."
      },
      {
        "id": 11,
        "question":
            "Topologi jaringan apa yang paling tahan terhadap kerusakan?",
        "imageUrl": null,
        "options": ["Bus", "Star", "Ring", "Mesh"],
        "correctAnswer": 3,
        "explanation":
            "Topologi mesh memberikan redundansi terbaik karena setiap node terhubung ke beberapa node lain, sehingga jika satu jalur rusak, masih ada jalur alternatif."
      },
      {
        "id": 12,
        "question": "Apa kepanjangan dari MAC address?",
        "imageUrl": null,
        "options": [
          "Media Access Control",
          "Machine Access Code",
          "Multiple Access Channel",
          "Master Access Controller"
        ],
        "correctAnswer": 0,
        "explanation":
            "MAC (Media Access Control) address adalah identifier unik yang diberikan kepada setiap network interface card."
      },
      {
        "id": 13,
        "question": "Protokol mana yang digunakan untuk transfer file?",
        "imageUrl": null,
        "options": ["HTTP", "FTP", "SMTP", "SNMP"],
        "correctAnswer": 1,
        "explanation":
            "FTP (File Transfer Protocol) adalah protokol standar untuk transfer file antara client dan server melalui jaringan."
      },
      {
        "id": 14,
        "question": "Berapa kelas IP address yang tersedia dalam IPv4?",
        "imageUrl": null,
        "options": ["3", "4", "5", "6"],
        "correctAnswer": 2,
        "explanation":
            "IPv4 memiliki 5 kelas IP address: Class A, B, C, D, dan E. Class A, B, C untuk unicast, Class D untuk multicast, dan Class E untuk eksperimental."
      },
      {
        "id": 15,
        "question": "Apa fungsi dari protokol DHCP?",
        "imageUrl": null,
        "options": [
          "Mengirim email",
          "Memberikan IP address secara otomatis",
          "Transfer file",
          "Browsing web"
        ],
        "correctAnswer": 1,
        "explanation":
            "DHCP (Dynamic Host Configuration Protocol) secara otomatis memberikan konfigurasi IP address kepada perangkat dalam jaringan."
      },
      {
        "id": 16,
        "question": "Apa itu bandwidth dalam jaringan?",
        "imageUrl": null,
        "options": [
          "Jumlah komputer dalam jaringan",
          "Kapasitas maksimal transfer data",
          "Jarak antar perangkat",
          "Waktu delay dalam jaringan"
        ],
        "correctAnswer": 1,
        "explanation":
            "Bandwidth adalah kapasitas maksimal transfer data yang dapat dilakukan dalam suatu jaringan dalam satuan waktu tertentu."
      },
      {
        "id": 17,
        "question": "Protokol mana yang beroperasi pada Layer 3 OSI Model?",
        "imageUrl": null,
        "options": ["Ethernet", "IP", "TCP", "HTTP"],
        "correctAnswer": 1,
        "explanation":
            "IP (Internet Protocol) beroperasi pada Layer 3 (Network Layer) dalam OSI Model dan bertanggung jawab untuk routing paket data."
      },
      {
        "id": 18,
        "question": "Apa kepanjangan dari LAN?",
        "imageUrl": null,
        "options": [
          "Large Area Network",
          "Local Area Network",
          "Long Area Network",
          "Limited Access Network"
        ],
        "correctAnswer": 1,
        "explanation":
            "LAN (Local Area Network) adalah jaringan komputer yang mencakup area geografis terbatas seperti rumah, kantor, atau gedung."
      },
      {
        "id": 19,
        "question": "Berapa maksimal panjang kabel UTP Cat5e?",
        "imageUrl": null,
        "options": ["50 meter", "100 meter", "150 meter", "200 meter"],
        "correctAnswer": 1,
        "explanation":
            "Panjang maksimal kabel UTP Cat5e adalah 100 meter (termasuk patch cord) untuk menjaga kualitas sinyal yang optimal."
      },
      {
        "id": 20,
        "question": "Apa fungsi dari protokol ARP?",
        "imageUrl": null,
        "options": [
          "Menerjemahkan IP ke MAC address",
          "Mengirim email",
          "Transfer file",
          "Routing paket data"
        ],
        "correctAnswer": 0,
        "explanation":
            "ARP (Address Resolution Protocol) berfungsi untuk menerjemahkan alamat IP menjadi alamat MAC dalam jaringan lokal."
      },
    ],
    'TEKWAN': [
      {
        "id": 1,
        "question": "Apa kepanjangan dari HTTP?",
        "imageUrl": null,
        "options": [
          "HyperText Transfer Protocol",
          "HyperText Transport Protocol",
          "HyperLink Transfer Protocol",
          "HyperMedia Transfer Protocol"
        ],
        "correctAnswer": 0,
        "explanation":
            "HTTP (HyperText Transfer Protocol) adalah protokol komunikasi untuk transfer data di World Wide Web."
      },
      {
        "id": 2,
        "question": "Web server mana yang paling populer digunakan?",
        "imageUrl": null,
        "options": ["Apache", "IIS", "Nginx", "Tomcat"],
        "correctAnswer": 0,
        "explanation":
            "Apache HTTP Server adalah web server yang paling banyak digunakan di dunia karena open source dan mudah dikonfigurasi."
      },
      // Continue with 18 more TEKWAN questions...
      {
        "id": 3,
        "question": "Apa kepanjangan dari SSL?",
        "imageUrl": null,
        "options": [
          "Secure Socket Layer",
          "Security Socket Link",
          "Safe Socket Layer",
          "System Security Layer"
        ],
        "correctAnswer": 0,
        "explanation":
            "SSL (Secure Socket Layer) adalah protokol keamanan untuk mengenkripsi komunikasi antara browser dan web server."
      },
      {
        "id": 4,
        "question": "Database server mana yang bersifat open source?",
        "imageUrl": null,
        "options": ["Oracle", "SQL Server", "MySQL", "DB2"],
        "correctAnswer": 2,
        "explanation":
            "MySQL adalah sistem manajemen database relasional yang bersifat open source dan gratis untuk digunakan."
      },
      {
        "id": 5,
        "question": "Port default untuk HTTPS adalah?",
        "imageUrl": null,
        "options": ["80", "443", "21", "25"],
        "correctAnswer": 1,
        "explanation":
            "HTTPS menggunakan port 443 sebagai port default untuk komunikasi web yang terenkripsi menggunakan SSL/TLS."
      },
      // Adding more TEKWAN questions
      {
        "id": 6,
        "question": "Apa fungsi dari load balancer?",
        "imageUrl": null,
        "options": [
          "Mengamankan server",
          "Mendistribusikan beban traffic",
          "Menyimpan backup",
          "Mengatur DNS"
        ],
        "correctAnswer": 1,
        "explanation":
            "Load balancer mendistribusikan incoming traffic ke beberapa server untuk mencegah overload pada satu server."
      },
      {
        "id": 7,
        "question": "Apa kepanjangan dari FTP?",
        "imageUrl": null,
        "options": [
          "File Transfer Protocol",
          "Fast Transfer Protocol",
          "File Transport Protocol",
          "Folder Transfer Protocol"
        ],
        "correctAnswer": 0,
        "explanation":
            "FTP (File Transfer Protocol) adalah protokol standar untuk transfer file antara client dan server."
      },
      {
        "id": 8,
        "question":
            "Cloud service model mana yang memberikan platform development?",
        "imageUrl": null,
        "options": ["IaaS", "PaaS", "SaaS", "DaaS"],
        "correctAnswer": 1,
        "explanation":
            "PaaS (Platform as a Service) menyediakan platform dan environment untuk mengembangkan aplikasi."
      },
      {
        "id": 9,
        "question": "Apa fungsi dari reverse proxy?",
        "imageUrl": null,
        "options": [
          "Menyembunyikan identitas client",
          "Melindungi server backend",
          "Mempercepat internet",
          "Mengatur DNS"
        ],
        "correctAnswer": 1,
        "explanation":
            "Reverse proxy bertindak sebagai perantara antara client dan server backend, melindungi server dari direct access."
      },
      {
        "id": 10,
        "question": "Database NoSQL mana yang paling populer?",
        "imageUrl": null,
        "options": ["Cassandra", "MongoDB", "Redis", "CouchDB"],
        "correctAnswer": 1,
        "explanation":
            "MongoDB adalah database NoSQL document-oriented yang paling populer dan banyak digunakan."
      },
      {
        "id": 11,
        "question": "Apa kepanjangan dari CDN?",
        "imageUrl": null,
        "options": [
          "Content Delivery Network",
          "Central Data Network",
          "Cloud Distribution Network",
          "Content Distribution Node"
        ],
        "correctAnswer": 0,
        "explanation":
            "CDN (Content Delivery Network) adalah jaringan server terdistribusi untuk mengirimkan konten web dengan cepat."
      },
      {
        "id": 12,
        "question": "Protokol mana yang digunakan untuk email yang aman?",
        "imageUrl": null,
        "options": ["SMTP", "SMTPS", "POP3", "IMAP"],
        "correctAnswer": 1,
        "explanation":
            "SMTPS (SMTP Secure) adalah versi aman dari SMTP yang menggunakan enkripsi SSL/TLS."
      },
      {
        "id": 13,
        "question": "Apa fungsi dari containerization?",
        "imageUrl": null,
        "options": [
          "Mempercepat aplikasi",
          "Isolasi aplikasi dan dependensinya",
          "Mengatur database",
          "Mengelola user"
        ],
        "correctAnswer": 1,
        "explanation":
            "Containerization mengisolasi aplikasi dan semua dependensinya dalam container yang portable dan ringan."
      },
      {
        "id": 14,
        "question": "Platform container mana yang paling populer?",
        "imageUrl": null,
        "options": ["Docker", "Podman", "LXC", "rkt"],
        "correctAnswer": 0,
        "explanation":
            "Docker adalah platform containerization yang paling populer dan banyak digunakan di industri."
      },
      {
        "id": 15,
        "question": "Apa kepanjangan dari API?",
        "imageUrl": null,
        "options": [
          "Application Programming Interface",
          "Automated Program Interface",
          "Application Protocol Interface",
          "Advanced Programming Interface"
        ],
        "correctAnswer": 0,
        "explanation":
            "API (Application Programming Interface) adalah set protokol dan tools untuk membangun aplikasi software."
      },
      {
        "id": 16,
        "question": "Format data mana yang paling umum untuk REST API?",
        "imageUrl": null,
        "options": ["XML", "JSON", "YAML", "CSV"],
        "correctAnswer": 1,
        "explanation":
            "JSON (JavaScript Object Notation) adalah format data yang paling umum digunakan dalam REST API karena ringan dan mudah dibaca."
      },
      {
        "id": 17,
        "question": "Apa fungsi dari web cache?",
        "imageUrl": null,
        "options": [
          "Mengamankan website",
          "Menyimpan data sementara untuk akses cepat",
          "Mengatur traffic",
          "Mengelola database"
        ],
        "correctAnswer": 1,
        "explanation":
            "Web cache menyimpan data website secara sementara untuk mempercepat akses dan mengurangi beban server."
      },
      {
        "id": 18,
        "question": "Microservice architecture memiliki keuntungan utama?",
        "imageUrl": null,
        "options": [
          "Lebih murah",
          "Scalability dan maintainability",
          "Lebih aman",
          "Lebih cepat"
        ],
        "correctAnswer": 1,
        "explanation":
            "Microservice architecture memberikan scalability dan maintainability yang lebih baik dengan memecah aplikasi menjadi service kecil."
      },
      {
        "id": 19,
        "question": "Apa fungsi dari message queue?",
        "imageUrl": null,
        "options": [
          "Menyimpan file",
          "Komunikasi asinkron antar service",
          "Mengatur user",
          "Mengelola DNS"
        ],
        "correctAnswer": 1,
        "explanation":
            "Message queue memungkinkan komunikasi asinkron antar service atau komponen dalam sistem terdistribusi."
      },
      {
        "id": 20,
        "question": "Cloud provider mana yang paling besar?",
        "imageUrl": null,
        "options": [
          "Google Cloud",
          "Microsoft Azure",
          "Amazon Web Services",
          "IBM Cloud"
        ],
        "correctAnswer": 2,
        "explanation":
            "Amazon Web Services (AWS) adalah cloud provider terbesar dengan market share tertinggi di dunia."
      },
    ],
    'ASJ': [
      {
        "id": 1,
        "question": "Apa kepanjangan dari OS?",
        "imageUrl": null,
        "options": [
          "Operating System",
          "Open System",
          "Online Service",
          "Output System"
        ],
        "correctAnswer": 0,
        "explanation":
            "OS (Operating System) adalah software yang mengelola hardware komputer dan menyediakan layanan untuk aplikasi."
      },
      {
        "id": 2,
        "question":
            "Sistem operasi Linux apa yang paling populer untuk server?",
        "imageUrl": null,
        "options": ["Ubuntu", "CentOS", "Debian", "Red Hat"],
        "correctAnswer": 0,
        "explanation":
            "Ubuntu adalah distribusi Linux yang paling populer untuk server karena user-friendly dan dukungan komunitas yang besar."
      },
      // Continue with 18 more ASJ questions...
      {
        "id": 3,
        "question": "Command untuk melihat daftar file di Linux adalah?",
        "imageUrl": null,
        "options": ["ls", "dir", "list", "show"],
        "correctAnswer": 0,
        "explanation":
            "Command 'ls' digunakan untuk menampilkan daftar file dan direktori dalam sistem operasi Linux."
      },
      {
        "id": 4,
        "question": "Apa fungsi dari cron job?",
        "imageUrl": null,
        "options": [
          "Mengelola user",
          "Menjalankan task secara terjadwal",
          "Mengatur network",
          "Memonitor sistem"
        ],
        "correctAnswer": 1,
        "explanation":
            "Cron job adalah scheduler yang memungkinkan menjalankan perintah atau script secara otomatis pada waktu yang ditentukan."
      },
      {
        "id": 5,
        "question": "File konfigurasi network di Ubuntu berada di?",
        "imageUrl": null,
        "options": [
          "/etc/network/interfaces",
          "/etc/network/config",
          "/etc/net/config",
          "/etc/interfaces"
        ],
        "correctAnswer": 0,
        "explanation":
            "File /etc/network/interfaces berisi konfigurasi network interface di sistem Ubuntu/Debian."
      },
      // Adding more ASJ questions
      {
        "id": 6,
        "question": "Command untuk mengubah permission file di Linux?",
        "imageUrl": null,
        "options": ["chmod", "chown", "chgrp", "change"],
        "correctAnswer": 0,
        "explanation":
            "Command 'chmod' (change mode) digunakan untuk mengubah permission atau hak akses file dan direktori."
      },
      {
        "id": 7,
        "question": "Apa fungsi dari systemctl?",
        "imageUrl": null,
        "options": [
          "Mengelola file",
          "Mengelola service systemd",
          "Mengatur network",
          "Memonitor CPU"
        ],
        "correctAnswer": 1,
        "explanation":
            "systemctl adalah command untuk mengelola service dan unit systemd dalam sistem Linux modern."
      },
      {
        "id": 8,
        "question": "Directory mana yang berisi log sistem di Linux?",
        "imageUrl": null,
        "options": ["/var/log", "/etc/log", "/usr/log", "/home/log"],
        "correctAnswer": 0,
        "explanation":
            "/var/log adalah direktori standar yang berisi semua file log sistem dan aplikasi di Linux."
      },
      {
        "id": 9,
        "question": "Command untuk melihat proses yang berjalan?",
        "imageUrl": null,
        "options": ["ps", "proc", "process", "tasks"],
        "correctAnswer": 0,
        "explanation":
            "Command 'ps' (process status) digunakan untuk menampilkan daftar proses yang sedang berjalan."
      },
      {
        "id": 10,
        "question": "Apa fungsi dari backup dalam sistem administrasi?",
        "imageUrl": null,
        "options": [
          "Mempercepat sistem",
          "Mengamankan data dari kehilangan",
          "Mengurangi storage",
          "Mengatur user"
        ],
        "correctAnswer": 1,
        "explanation":
            "Backup berfungsi untuk mengamankan data dari kehilangan akibat kerusakan hardware, human error, atau bencana."
      },
      {
        "id": 11,
        "question": "Tool monitoring sistem mana yang populer?",
        "imageUrl": null,
        "options": ["Nagios", "Apache", "MySQL", "Docker"],
        "correctAnswer": 0,
        "explanation":
            "Nagios adalah tool monitoring sistem yang populer untuk memantau infrastruktur IT dan aplikasi."
      },
      {
        "id": 12,
        "question": "Apa kepanjangan dari RAID?",
        "imageUrl": null,
        "options": [
          "Redundant Array of Independent Disks",
          "Random Access Independent Disk",
          "Reliable Array of Internal Disks",
          "Rapid Access Internal Drive"
        ],
        "correctAnswer": 0,
        "explanation":
            "RAID (Redundant Array of Independent Disks) adalah teknologi penyimpanan yang menggunakan multiple disk drives."
      },
      {
        "id": 13,
        "question": "Command untuk mengarsipkan file di Linux?",
        "imageUrl": null,
        "options": ["tar", "zip", "arc", "compress"],
        "correctAnswer": 0,
        "explanation":
            "Command 'tar' (tape archive) adalah tool standar untuk mengarsipkan dan mengekstrak file di sistem Linux."
      },
      {
        "id": 14,
        "question": "Apa fungsi dari firewall dalam sistem?",
        "imageUrl": null,
        "options": [
          "Mempercepat network",
          "Mengontrol akses jaringan",
          "Menyimpan data",
          "Mengelola user"
        ],
        "correctAnswer": 1,
        "explanation":
            "Firewall mengontrol akses jaringan dengan memfilter traffic berdasarkan aturan keamanan yang ditetapkan."
      },
      {
        "id": 15,
        "question": "Virtualization platform mana yang populer?",
        "imageUrl": null,
        "options": ["VMware", "Apache", "Nginx", "MySQL"],
        "correctAnswer": 0,
        "explanation":
            "VMware adalah platform virtualization yang populer untuk menjalankan multiple virtual machines."
      },
      {
        "id": 16,
        "question": "Apa fungsi dari SSH?",
        "imageUrl": null,
        "options": [
          "Transfer file",
          "Remote access yang aman",
          "Browsing web",
          "Mengirim email"
        ],
        "correctAnswer": 1,
        "explanation":
            "SSH (Secure Shell) menyediakan akses remote yang aman ke sistem melalui koneksi terenkripsi."
      },
      {
        "id": 17,
        "question": "Command untuk melihat penggunaan disk space?",
        "imageUrl": null,
        "options": ["df", "du", "disk", "space"],
        "correctAnswer": 0,
        "explanation":
            "Command 'df' (disk free) menampilkan informasi penggunaan disk space pada filesystem yang ter-mount."
      },
      {
        "id": 18,
        "question": "Apa fungsi dari package manager?",
        "imageUrl": null,
        "options": [
          "Mengelola file",
          "Menginstal dan mengupdate software",
          "Mengatur network",
          "Memonitor sistem"
        ],
        "correctAnswer": 1,
        "explanation":
            "Package manager mengelola instalasi, update, dan penghapusan software package dalam sistem operasi."
      },
      {
        "id": 19,
        "question":
            "Automation tool mana yang populer untuk sistem administrasi?",
        "imageUrl": null,
        "options": ["Ansible", "Apache", "MySQL", "Docker"],
        "correctAnswer": 0,
        "explanation":
            "Ansible adalah automation tool yang populer untuk konfigurasi manajemen dan deployment aplikasi."
      },
      {
        "id": 20,
        "question": "Apa fungsi dari load average dalam monitoring?",
        "imageUrl": null,
        "options": [
          "Mengukur storage",
          "Mengukur beban sistem",
          "Mengukur network",
          "Mengukur memory"
        ],
        "correctAnswer": 1,
        "explanation":
            "Load average mengukur rata-rata beban sistem berdasarkan jumlah proses yang menunggu untuk dieksekusi."
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
    _initializeAnimations();
  }

  void _initializeQuiz() {
    // Get subject from route arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['subject'] != null) {
      _selectedSubject = args['subject'];
    }

    _quizStartTime = DateTime.now();
  }

  void _initializeAnimations() {
    _pageController = PageController();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _questionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _questionSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _questionController,
      curve: Curves.easeOutCubic,
    ));

    _questionController.forward();
    _updateProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    final progress = (_currentQuestionIndex + 1) / _currentQuizData.length;
    _progressController.animateTo(progress);
  }

  List<Map<String, dynamic>> get _currentQuizData {
    return _subjectQuizzes[_selectedSubject] ?? [];
  }

  void _selectAnswer(int answerIndex) {
    if (_userAnswers.containsKey(_currentQuestionIndex)) return;

    setState(() {
      _userAnswers[_currentQuestionIndex] = answerIndex;
    });

    HapticFeedback.selectionClick();

    // Auto advance after short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _currentQuestionIndex < _currentQuizData.length - 1) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _currentQuizData.length - 1) {
      _questionController.reset();
      setState(() {
        _currentQuestionIndex++;
      });
      _questionController.forward();
      _updateProgress();

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _questionController.reset();
      setState(() {
        _currentQuestionIndex--;
      });
      _questionController.forward();
      _updateProgress();

      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishQuiz() {
    _quizEndTime = DateTime.now();

    setState(() {
      _quizCompleted = true;
      _showResults = true;
    });

    HapticFeedback.heavyImpact();
  }

  void _toggleFlag() {
    setState(() {
      if (_flaggedQuestions.contains(_currentQuestionIndex)) {
        _flaggedQuestions.remove(_currentQuestionIndex);
      } else {
        _flaggedQuestions.add(_currentQuestionIndex);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _showQuestionReview() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => EnhancedQuizReviewWidget(
        quizData: _currentQuizData,
        userAnswers: _userAnswers,
        flaggedQuestions: _flaggedQuestions,
        currentQuestionIndex: _currentQuestionIndex,
        onQuestionTap: (index) {
          Navigator.pop(context);
          _goToQuestion(index);
        },
      ),
    );
  }

  void _goToQuestion(int index) {
    _questionController.reset();
    setState(() {
      _currentQuestionIndex = index;
    });
    _questionController.forward();
    _updateProgress();

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _retakeQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _userAnswers.clear();
      _flaggedQuestions.clear();
      _quizCompleted = false;
      _showResults = false;
      _quizStartTime = DateTime.now();
      _quizEndTime = null;
    });

    _questionController.reset();
    _questionController.forward();
    _updateProgress();

    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _continueLearning() {
    Navigator.pushReplacementNamed(context, '/skill-detail');
  }

  void _exitQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Keluar dari Kuis?',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Progres kuis Anda akan hilang jika keluar sekarang. Apakah Anda yakin?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.backgroundWhite,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  int get _correctAnswersCount {
    int correct = 0;
    _userAnswers.forEach((questionIndex, answerIndex) {
      if (answerIndex == _currentQuizData[questionIndex]['correctAnswer']) {
        correct++;
      }
    });
    return correct;
  }

  double get _scorePercentage {
    if (_userAnswers.isEmpty) return 0.0;
    return (_correctAnswersCount / _currentQuizData.length) * 100;
  }

  Duration get _quizDuration {
    if (_quizStartTime == null) return Duration.zero;
    final endTime = _quizEndTime ?? DateTime.now();
    return endTime.difference(_quizStartTime!);
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return EnhancedQuizResultsWidget(
        subject: _selectedSubject,
        totalQuestions: _currentQuizData.length,
        correctAnswers: _correctAnswersCount,
        scorePercentage: _scorePercentage,
        quizDuration: _quizDuration,
        quizData: _currentQuizData,
        userAnswers: _userAnswers,
        onRetakeQuiz: _retakeQuiz,
        onContinueLearning: _continueLearning,
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: EnhancedQuizHeaderWidget(
          subject: _selectedSubject,
          currentQuestion: _currentQuestionIndex + 1,
          totalQuestions: _currentQuizData.length,
          progressAnimation: _progressAnimation,
          onExit: _exitQuiz,
          onReview: _showQuestionReview,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Question content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _currentQuizData.length,
                itemBuilder: (context, index) {
                  return SlideTransition(
                    position: _questionSlideAnimation,
                    child: EnhancedQuizQuestionWidget(
                      questionData: _currentQuizData[index],
                      questionNumber: index + 1,
                      totalQuestions: _currentQuizData.length,
                      selectedAnswer: _userAnswers[index],
                      isFlagged: _flaggedQuestions.contains(index),
                      onAnswerSelected: _selectAnswer,
                      onToggleFlag: _toggleFlag,
                    ),
                  );
                },
              ),
            ),

            // Navigation controls
            EnhancedQuizNavigationWidget(
              currentQuestion: _currentQuestionIndex + 1,
              totalQuestions: _currentQuizData.length,
              hasAnswer: _userAnswers.containsKey(_currentQuestionIndex),
              onPrevious: _currentQuestionIndex > 0 ? _previousQuestion : null,
              onNext: _userAnswers.containsKey(_currentQuestionIndex)
                  ? (_currentQuestionIndex < _currentQuizData.length - 1
                      ? _nextQuestion
                      : _finishQuiz)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

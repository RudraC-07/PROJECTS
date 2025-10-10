import 'package:flutter/material.dart';
import 'package:gym_mania/constants/app_constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Color(0xFF2C2C2C)],
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          // Welcome Header Section
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF1A1A1A)],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 25, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: Center(
                            child: Column(
                              children: [
                                // App Logo
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.25),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.fitness_center_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'GYM MANIA',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Your fitness journey starts here',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Curved bottom section
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),

                // Meet Our Team Section
                _buildSectionCard(
                  'Meet Our Team',
                  Icons.group_rounded,
                  [
                    _buildTeamInfoRow('Developed by', 'Rudra Chavda (23010101048)'),
                    _buildTeamInfoRow('Mentored by', 'Prof. Mehul Bhundiya (Computer Engineering Department)'),
                    _buildTeamInfoRow('School', 'School of Computer Science'),
                    _buildTeamInfoRow('Explored by', 'ASWDC, School of Computer Science'),
                    _buildTeamInfoRow('University', 'Darshan University, Rajkot, Gujarat - INDIA'),
                  ],
                ),

                const SizedBox(height: 24),

                // About ASWDC Section
                _buildSectionCard(
                  'About ASWDC',
                  Icons.business_rounded,
                  [
                    const SizedBox(height: 8),
                     Row(
                       children: [
                         Expanded(
                           child: Container(
                             height: 120,
                             decoration: BoxDecoration(
                               color: Colors.grey[100],
                               borderRadius: BorderRadius.circular(16),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.black.withOpacity(0.1),
                                   blurRadius: 10,
                                   offset: const Offset(0, 4),
                                 ),
                               ],
                             ),
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(16),
                               child: Image.asset(
                                 'assets/images/ASWDC.jpg',
                                 fit: BoxFit.contain,
                                 width: double.infinity,
                                 height: double.infinity,
                                 errorBuilder: (context, error, stackTrace) {
                                   return Container(
                                     color: Colors.grey[300],
                                     child: const Icon(
                                       Icons.image_not_supported,
                                       size: 40,
                                       color: Colors.grey,
                                     ),
                                   );
                                 },
                               ),
                             ),
                           ),
                         ),
                         const SizedBox(width: 22),
                         Expanded(
                           child: Container(
                             height: 120,
                             decoration: BoxDecoration(
                               color: Colors.grey[100],
                               borderRadius: BorderRadius.circular(16),
                               boxShadow: [
                                 BoxShadow(
                                   color: Colors.black.withOpacity(0.1),
                                   blurRadius: 10,
                                   offset: const Offset(0, 4),
                                 ),
                               ],
                             ),
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(16),
                               child: Image.asset(
                                 'assets/images/DU_LOGO.jpg',
                                 fit: BoxFit.contain,
                                 width: double.infinity,
                                 height: double.infinity,
                                 errorBuilder: (context, error, stackTrace) {
                                   return Container(
                                     color: Colors.grey[300],
                                     child: const Icon(
                                       Icons.image_not_supported,
                                       size: 40,
                                       color: Colors.grey,
                                     ),
                                   );
                                 },
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                    const SizedBox(height: 20),
                    // Image labels
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Text(
                    //         'ASWDC',
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w600,
                    //           color: AppConstants.primaryColor,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     Expanded(
                    //       child: Text(
                    //         'Darshan University',
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w600,
                    //           color: AppConstants.primaryColor,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      'ASWDC is Application, Software and Website Development Center @ Darshan University run by Students and Staff of School Of Computer Science.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sole purpose of ASWDC is to bridge gap between university curriculum & industry demands. Students learn cutting edge technologies, develop real world application & experiences professional environment @ ASWDC under guidance of industry experts & faculty members.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Contact Us Section
                _buildSectionCard(
                  'Contact Us',
                  Icons.contact_support_rounded,
                  [
                    _buildContactRow(Icons.email_rounded, 'contact@example.com'),
                    _buildContactRow(Icons.phone_rounded, '+1-234-567-8900'),
                    _buildContactRow(Icons.language_rounded, 'www.example.com'),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons Section
                _buildSectionCard(
                  'Quick Actions',
                  Icons.apps_rounded,
                  [
                    _buildActionButton(Icons.share_rounded, 'Share App', () {}),
                    _buildActionButton(Icons.apps_rounded, 'More Apps', () {}),
                    _buildActionButton(Icons.star_rounded, 'Rate Us', () {}),
                    _buildActionButton(Icons.thumb_up_rounded, 'Like us on Facebook', () {}),
                    _buildActionButton(Icons.update_rounded, 'Check For Update', () {}),
                  ],
                ),

                const SizedBox(height: 32),

                // Footer
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '© 2025 Darshan University',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'All Rights Reserved - ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Made with ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.red[400],
                            size: 16,
                          ),
                          Text(
                            ' in India',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[700],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$title:',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    color: AppConstants.primaryColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

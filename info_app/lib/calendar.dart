import 'package:flutter/material.dart';
import 'package:info_app/events_data.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  @override
  Widget build(BuildContext context) {
    // Group events by month and date
    final groupedEvents = groupEventsByMonth(events);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: groupedEvents.length,
          itemBuilder: (context, index) {
            final month = groupedEvents.keys.elementAt(index);
            final monthEvents = groupedEvents[month]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month header
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    month,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                ...monthEvents.entries.map((entry) {
                  final date = entry.key;
                  final eventList = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date card
                        Container(
                          width: 80,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  date.split(' ')[0],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  date.split(' ')[1],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Events list for the date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: eventList.map((event) {
                              return EventCard(
                                title: event['title']!,
                                time: event['time']!,
                                location: event['location']!,
                                type: event['type']!,
                                isHome: false,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  // Function to group events by month and date
  Map<String, Map<String, List<Map<String, String>>>> groupEventsByMonth(List<Map<String, String>> events) {
    final Map<String, Map<String, List<Map<String, String>>>> groupedEvents = {};
    for (var event in events) {
      final month = event['month']!;
      final date = event['date']!;
      if (groupedEvents[month] == null) {
        groupedEvents[month] = {};
      }
      if (groupedEvents[month]![date] == null) {
        groupedEvents[month]![date] = [];
      }
      groupedEvents[month]![date]!.add(event);
    }
    return groupedEvents;
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String time;
  final String location;
  final String type;
  
  final bool isHome;

  const EventCard({super.key, 
    required this.title,
    required this.time,
    required this.location,
    required this.type,

    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Chip(
              label: Text(type),
              backgroundColor: type == 'Workshop' ? Colors.blueAccent : Colors.teal,
              labelStyle: const TextStyle(color: Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            ),
            const Spacer(),
            if (!isHome)
              Text(location),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        if (isHome)
          const Spacer()
        else
          const SizedBox(height: 8),        
        Row(
          children: [
            if (!isHome)
              const Icon(Icons.access_time, size: 16),
            const SizedBox(width: 4),
            Text(time),
          ],
        ),
      ],
    );
      
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: isHome
          ? Container(
              width: 250,
              height: 160,
              padding: const EdgeInsets.all(12.0),
              child: content,
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: content,
            )
          ),
      );
  }
}
